require File.join(File.dirname(__FILE__), '..', 'flapjack_rest')

Puppet::Type.type(:flapjack_media).provide :rest, :parent => Puppet::Provider::Rest do
  desc "REST provider for Flapjack Media"
  
  mk_resource_methods

  def flush      
    Puppet.debug "Flapjack Media - Flush Started"
      
    if @property_flush[:ensure] == :absent
      deleteMedia
      return
    end
    
    if @property_flush[:ensure] == :present
      createMedia
      return
    end
    
    updateMedia
  end  

  def self.instances
    result = Array.new
        
    media = get_objects('media', 'media')
    if media != nil
      media.each do |medium|
        Puppet.debug "Medium FOUND. ID = "+medium["id"].to_s
        
        list = getMediaObjects(medium)
        list.each do |map|          
          if map != nil
           #Puppet.debug "Media Object: "+map.inspect
           result.push(new(map))
          end  
        end        
      end
    end
    
    result 
  end
  
  def self.getMedia(id)
    media = get_objects("media/#{id}", 'media')
   
    if media != nil
      media.each do |medium|
        #Puppet.debug "Media FOUND. ID = "+medium["id"].to_s

        list = getMediaObjects(medium)
        list.each do |map|          
          if map != nil
           #Puppet.debug "Media Object: "+map.inspect
           return map
          end  
        end
       end
    end
  end

  def self.getMediaObjects(object)   
    if object["id"] != nil
      if object["links"]["contacts"] != nil
        contacts = object["links"]["contacts"]
      else  
        contacts = Array.new    
      end
      
      contacts.collect do |contact|        
        {
          :name             => object["id"],   
          :type             => object["type"],  
          :address          => object["address"],  
          :interval         => object["interval"].to_s,  
          :rollup_threshold => object["rollup_threshold"].to_s,            
          :contact          => contact,  
          :ensure           => :present
        }        
      end
    end
  end

  # TYPE SPECIFIC        
  private
  def createMedia
    Puppet.debug "Create Media "+resource[:name]

    medium = {         
      :type             => resource[:type],
      :address          => resource[:address],
      :interval         => resource[:interval],
      :rollup_threshold => resource[:rollup_threshold],
    }
               
    media = Array.new
    media.push medium

    params = {
      :media => media,
    }
    
    #Puppet.debug "POST media PARAMS = "+params.inspect
    response = self.class.http_post("contacts/#{resource[:contact]}/media", params)
  end

  def deleteMedia
    Puppet.debug "Delete Media "+resource[:name]

    #Puppet.debug "DELETE media/#{resource[:name]}/"
    response = self.class.http_delete("media/#{resource[:name]}")
  end
      
  def updateMedia
    Puppet.debug "Update Media "+resource[:name]
   
    current = self.class.getMedia(resource[:name])

    operations = Array.new
      
    if resource[:address] != current[:address]
      op = {
        :op    => 'replace',
        :path  => '/media/0/address',
        :value => resource[:address],
      }
      operations.push op
    end
      
    if resource[:interval] != current[:interval]
      op = {
        :op    => 'replace',
        :path  => '/media/0/interval',
        :value => resource[:interval],
      }
      operations.push op
    end

    if resource[:rollup_threshold] != current[:rollup_threshold]
      op = {
        :op    => 'replace',
        :path  => '/media/0/rollup_threshold',
        :value => resource[:rollup_threshold],
      }
      operations.push op
    end
    
    #Puppet.debug "PATCH media/#{resource[:name]} PARAMS = "+operations.inspect
    response = self.class.http_patch("media/#{resource[:name]}", operations)
  end
end