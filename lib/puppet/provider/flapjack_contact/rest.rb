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

      {
        :name            => object["id"],   
        :first_name      => object["first_name"],  
        :last_name       => object["last_name"],  
        :email           => object["email"],  
        :timezone        => object["timezone"],  
        #:contact_tags    => tags,  
        :linked_entities => entities,
        :ensure          => :present
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
    
    # Immediately update to link to an entity
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
      
    if resource[:first_name] != current[:first_name]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/first_name',
        :value => resource[:first_name],
      }
      operations.push op
    end
      
    if resource[:last_name] != current[:last_name]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/last_name',
        :value => resource[:last_name],
      }
      operations.push op
    end
    
    if resource[:email] != current[:email]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/email',
        :value => resource[:email],
      }
      operations.push op
    end
    
    if resource[:timezone] != current[:timezone]
      op = {
        :op    => 'replace',
        :path  => '/contacts/0/timezone',
        :value => resource[:timezone],
      }
      operations.push op
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
      end

      remove.each do |entity|
        op = {
          :op    => 'remove',
          :path  => '/contacts/0/links/entities',
          :value => entity,
        }
        operations.push op
      end
    end
    
    Puppet.debug "PATCH contacts/#{resource[:name]} PARAMS = "+operations.inspect
    response = self.class.http_patch("contacts/#{resource[:name]}", operations)
  end
end