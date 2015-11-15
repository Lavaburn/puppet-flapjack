require File.join(File.dirname(__FILE__), '..', 'flapjack_rest')

Puppet::Type.type(:flapjack_entity).provide :rest, :parent => Puppet::Provider::FlapjackRest do
  desc "REST provider for Flapjack Entity"
  
  mk_resource_methods

  def flush
    #Puppet.debug "Flapjack Entity - Flush Started"
      
    if @property_flush[:ensure] == :absent
      deleteEntity
      return
    end
    
    if @property_flush[:ensure] == :present
      createEntity
      return
    end
    
    updateEntity
  end

  def self.instances
    result = Array.new
        
    entities = get_objects('entities', 'entities')
    if entities != nil
      entities.each do |entity|
        Puppet.debug "Entity FOUND. ID = "+entity["id"].to_s
        
        map = getEntityObj(entity)
        if map != nil
         #Puppet.debug "Entity Object: "+map.inspect
         result.push(new(map))
        end  
      end
    end
    
    result 
  end

  def self.getEntity(id)
    entities = get_objects("entities/#{id}", 'entities')
    
    if entities != nil
      entities.each do |entity|
        #Puppet.debug "Entity FOUND. ID = "+entity["id"].to_s
            
        map = getEntityObj(entity)
        if map != nil
          #Puppet.debug "Entity Object: "+map.inspect
          return map
        end  
       end
    end
  end
  
  def self.getEntityObj(object)   
    if object["id"] != nil   
# TODO - tags are not currently used - they are links and not direct parameters !!
#      tags = Array.new
#      object["tags"].each do |tag|
#        tags.push(tag)
#      end      
          
      {
        :id          => object["id"],   
        :name        => object["name"], 
#        :entity_tags => tags,  
        :ensure      => :present
      }
    end
  end
 
  # TYPE SPECIFIC        
  private
  def createEntity
    Puppet.debug "Create Entity "+resource[:id]
      
    entity = {         
      :id   => resource[:id],
      :name => resource[:name],
#      :tags => resource[:entity_tags],
    }
            
    entities = Array.new
    entities.push entity
    
    params = {
      :entities => entities,
    }
    
    #Puppet.debug "POST entities PARAMS = "+params.inspect
    response = self.class.http_post('entities', params)
  end

  def deleteEntity
    Puppet.debug "Delete Entity "+resource[:id]

    #Puppet.debug "DELETE entities/#{resource[:id]}/"
    response = self.class.http_delete("entities/#{resource[:id]}")
  end
      
  def updateEntity
    Puppet.debug "Update Entity "+resource[:id]
      
    current = self.class.getEntity(resource[:id])

    operations = Array.new
      
    if resource[:name] != current["name"]
      op = {
        :op    => 'replace',
        :path  => '/entities/0/name',
        :value => resource[:name],
      }
      operations.push op
    end
    
#    if resource[:tags] != current["tags"]
#      op = {
#        :op    => 'replace',   # one of replace (for attributes), add or remove (for linked objects)
#        :path  => '/entities/0/tags',
#        :value => resource[:tags],
#      }
#      operations.push op
#    end
    # => Tags update (add/remove) => /entities/0/links/tags/database ???    
    
    #Puppet.debug "PATCH entities/#{resource[:id]} PARAMS = "+operations.inspect
    response = self.class.http_patch("entities/#{resource[:id]}", operations)
  end
end