require File.join(File.dirname(__FILE__), '..', 'flapjack_rest')

Puppet::Type.type(:flapjack_notification_rule).provide :rest, :parent => Puppet::Provider::FlapjackRest do
  desc "REST provider for Flapjack Notification Rule"
  
  mk_resource_methods

  def flush      
    #Puppet.debug "Flapjack Notification Rule - Flush Started"
      
    if @property_flush[:ensure] == :absent
      deleteRule
      return
    end
    
    if @property_flush[:ensure] == :present
      createRule
      return
    end
    
    updateRule
  end  

  def self.instances
    result = Array.new
        
    rules = get_objects('notification_rules', 'notification_rules')
    if rules != nil
      rules.each do |rule|
        Puppet.debug "Notification Rule FOUND. ID = "+rule["id"].to_s
        
        list = getRuleObjects(rule)
        list.each do |map|          
          if map != nil
            #Puppet.debug "Notification Rule Object: "+map.inspect
            result.push(new(map))
          end  
        end
      end
    end
    
    result 
  end
  
  def self.getRule(id)
    rules = get_objects("notification_rules/#{id}", 'notification_rules')
    
    if rules != nil
      rules.each do |rule|
        #Puppet.debug "Notification Rule FOUND. ID = "+rule["id"].to_s
            
        list = getRuleObjects(rule)
        list.each do |map|          
          if map != nil
           #Puppet.debug "Notification Rule Object: "+map.inspect
           return map
          end  
        end
      end
    end
  end

  def self.getRuleObjects(object)   
    if object["id"] != nil       
      if object["links"]["contacts"] != nil
        contacts = object["links"]["contacts"]
      else  
        contacts = Array.new    
      end
            
      contacts.collect do |contact|
        {
          :name               => object["id"],   
          :contact            => contact,
          :entities           => object["entities"],
          :regex_entities     => object["regex_entities"],
          :tags               => object["tags"],
          :regex_tags         => object["regex_tags"],
          :time_restrictions  => object["time_restrictions"],
          :unknown_media      => object["unknown_media"],
          :warning_media      => object["warning_media"],
          :critical_media     => object["critical_media"],
          :unknown_blackhole  => object["unknown_blackhole"],
          :warning_blackhole  => object["warning_blackhole"],
          :critical_blackhole => object["critical_blackhole"],
          :ensure             => :present
        }
      end
    end
  end

  # TYPE SPECIFIC        
  private
  def createRule
    Puppet.debug "Create Notification Rule "+resource[:name]
      
    rule = {         
      :id                 => resource[:name],
      :contact            => resource[:contact],
      :entities           => resource[:entities],
      :regex_entities     => resource[:regex_entities],
      :tags               => resource[:tags],
      :regex_tags         => resource[:regex_tags],
      :time_restrictions  => resource[:time_restrictions],
      :unknown_media      => resource[:unknown_media],
      :warning_media      => resource[:warning_media],
      :critical_media     => resource[:critical_media],
      :unknown_blackhole  => resource[:unknown_blackhole],
      :warning_blackhole  => resource[:warning_blackhole],
      :critical_blackhole => resource[:critical_blackhole],
    }
                
    rules = Array.new
    rules.push rule
   
    params = {
      :notification_rules   => rules,
    }
    
    #Puppet.debug "POST notification_rules PARAMS = "+params.inspect
    response = self.class.http_post("contacts/#{resource[:contact]}/notification_rules", params)
  end

  def deleteRule
    Puppet.debug "Delete Notification Rule "+resource[:name]

    #Puppet.debug "DELETE notification_rules/#{resource[:name]}"
    response = self.class.http_delete("notification_rules/#{resource[:name]}")
  end
      
  def updateRule
    Puppet.debug "Update Notification Rule "+resource[:name]
      
    current = self.class.getRule(resource[:name])

    operations = Array.new
    
#    if resource[:contact] != current[:contact]
#      op = {
#        :op    => 'replace',
#        :path  => '/contacts/0/contact',
#        :value => resource[:contact],
#      }
#      operations.push op
#    end
    
    if resource[:entities] != current[:entities]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/entities',
        :value => resource[:entities],
      }
      operations.push op
    end
    
    if resource[:regex_entities] != current[:regex_entities]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/regex_entities',
        :value => resource[:regex_entities],
      }
      operations.push op
    end

    if resource[:tags] != current[:tags]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/tags',
        :value => resource[:tags],
      }
      operations.push op
    end
    
    if resource[:regex_tags] != current[:regex_tags]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/regex_tags',
        :value => resource[:regex_tags],
      }
      operations.push op
    end
    
    if resource[:time_restrictions] != current[:time_restrictions]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/time_restrictions',
        :value => resource[:time_restrictions],
      }
      operations.push op
    end

    if resource[:unknown_media] != current[:unknown_media]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/unknown_media',
        :value => resource[:unknown_media],
      }
      operations.push op
    end

    if resource[:warning_media] != current[:warning_media]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/warning_media',
        :value => resource[:warning_media],
      }
      operations.push op
    end

    if resource[:critical_media] != current[:critical_media]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/critical_media',
        :value => resource[:critical_media],
      }
      operations.push op
    end            
    
    unknown_blackhole = resource[:unknown_blackhole]
    warning_blackhole = resource[:warning_blackhole]
    critical_blackhole = resource[:critical_blackhole]
      
    if unknown_blackhole != current[:unknown_blackhole]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/unknown_blackhole',
        :value => unknown_blackhole,
      }
      operations.push op
    end          
    
    if warning_blackhole != current[:warning_blackhole]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/warning_blackhole',
        :value => warning_blackhole,
      }
      operations.push op
    end          
    
    if critical_blackhole != current[:critical_blackhole]
      op = {
        :op    => 'replace',
        :path  => '/notification_rules/0/critical_blackhole',
        :value => critical_blackhole,
      }
      operations.push op
    end
    
    Puppet.debug "PATCH notification_rules/#{resource[:name]} PARAMS = "+operations.inspect
    response = self.class.http_patch("notification_rules/#{resource[:name]}", operations)
  end
end