require File.join(File.dirname(__FILE__), '..', 'flapjack_rest')

Puppet::Type.type(:flapjack_contact).provide :rest, :parent => Puppet::Provider::FlapjackRest do
  desc "REST provider for Flapjack Contact"
  
  mk_resource_methods

  def flush      
    Puppet.debug "Flapjack Contact - Flush Started"
      
    if @property_flush[:ensure] == :absent
      deleteContact
      return
    end
    
    if @property_flush[:ensure] == :present
      createContact
      return
    end
    
    updateContact
  end  

  def self.instances
    result = Array.new
        
    contacts = get_objects('contacts', 'contacts')
    if contacts != nil
      contacts.each do |contact|
        Puppet.debug "Contact FOUND. ID = "+contact["id"].to_s
        
        map = getContactObj(contact)
        if map != nil
         #Puppet.debug "Contact Object: "+map.inspect
         result.push(new(map))
        end  
      end
    end
    
    result 
  end
  
  def self.getContact(id)
    contacts = get_objects("contacts/#{id}", 'contacts')
    
    if contacts != nil
      contacts.each do |contact|
        #Puppet.debug "Contact FOUND. ID = "+contact["id"].to_s
            
        map = getContactObj(contact)
        if map != nil
          Puppet.debug "Contact Object: "+map.inspect
          return map
        end  
       end
    end
  end

  def self.getContactObj(object)   
    if object["id"] != nil   
# TODO - tags are not currently used - they are links and not direct parameters !!
#      tags = Array.new
#      object["tags"].each do |tag|
#       tags.push(tag)
#      end     

      entities = Array.new
      object["links"]["entities"].each do |entity|
        entities.push(entity)
      end
      
      ruleId = findDefaultNotificationRule(object["id"])
      default_rule_blackholes = getBlackHoles(ruleId)

      {
        :name                    => object["id"],   
        :first_name              => object["first_name"],  
        :last_name               => object["last_name"],  
        :email                   => object["email"],  
        :timezone                => object["timezone"],  
        #:contact_tags            => tags,  
        :linked_entities         => entities,
        :default_rule_blackholes => default_rule_blackholes,
        :ensure                  => :present
      }
    end
  end
  
  # TYPE SPECIFIC        
  private
  def createContact
    Puppet.debug "Create Contact "+resource[:name]
      
    contact = {         
      :id         => resource[:name],
      :first_name => resource[:first_name],
      :last_name  => resource[:last_name],
      :email      => resource[:email],
      :timezone   => resource[:timezone],
#      :tags       => resource[:contact_tags],
    }
                
    contacts = Array.new
    contacts.push contact
    
    params = {
      :contacts   => contacts,
    }
    
    #Puppet.debug "POST contacts PARAMS = "+params.inspect
    response = self.class.http_post('contacts', params)
    
    # Immediately update to link to an entity and set blackholes on default notification rule
    updateContact
  end

  def deleteContact
    Puppet.debug "Delete Contact "+resource[:name]

    #Puppet.debug "DELETE contacts/#{resource[:name]}/"
    response = self.class.http_delete("contacts/#{resource[:name]}")
  end
      
  def updateContact
    Puppet.debug "Update Contact "+resource[:name]
      
    current = self.class.getContact(resource[:name])

    operations = Array.new    
    patch_contact = false
      
    if resource[:first_name] != current[:first_name]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/first_name',
        :value => resource[:first_name],
      }
      operations.push op
      patch_contact = true
    end
      
    if resource[:last_name] != current[:last_name]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/last_name',
        :value => resource[:last_name],
      }
      operations.push op
      patch_contact = true
    end
    
    if resource[:email] != current[:email]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/email',
        :value => resource[:email],
      }
      operations.push op
      patch_contact = true
    end
    
    if resource[:timezone] != current[:timezone]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/timezone',
        :value => resource[:timezone],
      }
      operations.push op
      patch_contact = true
    end
    
    if resource[:linked_entities] != current[:linked_entities]
      add = resource[:linked_entities] - current[:linked_entities]
      remove = current[:linked_entities] - resource[:linked_entities]
      
      add.each do |entity|
        op = {
          :op    => 'add',
          :path  => '/contacts/0/links/entities',
          :value => entity,
        }
        operations.push op
        patch_contact = true
      end

      remove.each do |entity|
        op = {
          :op    => 'remove',
          :path  => '/contacts/0/links/entities',
          :value => entity,
        }
        operations.push op
        patch_contact = true
      end
    end
    
    if patch_contact
      Puppet.debug "PATCH contacts/#{resource[:name]} PARAMS = "+operations.inspect
      response = self.class.http_patch("contacts/#{resource[:name]}", operations)
    end
    
    if resource[:default_rule_blackholes] != current[:default_rule_blackholes]
      ruleId = self.class.findDefaultNotificationRule(resource[:name])
      
      operations = Array.new

      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/critical_blackhole',
        :value => (resource[:default_rule_blackholes].include?"critical"),
      }
      operations.push op

      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/warning_blackhole',
        :value => (resource[:default_rule_blackholes].include?"warning"),
      }
      operations.push op
      
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/unknown_blackhole',
        :value => (resource[:default_rule_blackholes].include?"unknown"),
      }
      operations.push op
      
      Puppet.debug "PATCH notification_rules/#{ruleId} PARAMS = "+operations.inspect
      response = self.class.http_patch("notification_rules/#{ruleId}", operations)
    end
  end
  
  def self.findDefaultNotificationRule(contact_id)   
    contacts = get_objects("contacts/#{contact_id}", 'contacts')
    if contacts != nil
      contacts.each do |contact|
        #Puppet.debug "Contact FOUND. ID = "+contact["id"].to_s
        rules = contact["links"]["notification_rules"]        
        rules.each do |rule|
          if (!rule.start_with?(contact["name"]))  # Enforced by the Puppet implementation
            return rule
          end
        end
      end
    end
    
    return "" # TODO FAILURE ?
  end
  
  def self.getBlackHoles(ruleId)   
    result = Array.new
    
    rules = get_objects("notification_rules/#{ruleId}", 'notification_rules')
    if rules != nil
      rules.each do |rule|
        #Puppet.debug "Notification Rule FOUND. ID = "+rule["id"].to_s

        if rule["critical_blackhole"] 
          result.push "critical"
        end
        if rule["warning_blackhole"] 
          result.push "warning"
        end
        if rule["unknown_blackhole"] 
          result.push "unknown"
        end
         
      end
    end
    
    return result      
  end
end