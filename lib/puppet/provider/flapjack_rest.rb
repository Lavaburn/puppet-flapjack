begin
  require 'rest-client' if Puppet.features.rest_client?
  require 'json' if Puppet.features.json?
  require 'yaml/store' if Puppet.features.yaml?
rescue LoadError => e
  Puppet.info "Flapjack Puppet module requires 'rest-client' and 'json' ruby gems."
end

class Puppet::Provider::FlapjackRest < Puppet::Provider
  desc "Flapjack API REST calls"
  
  confine :feature => :json
  confine :feature => :yaml
  confine :feature => :rest_client
  
  def initialize(value={})
    super(value)
    @property_flush = {} 
  end
    
  def self.get_rest_info
    config_file = "/etc/flapjack/puppet_api.yaml"

    data = File.read(config_file) or raise "Could not read setting file #{config_file}"    
    yamldata = YAML.load(data)

    if yamldata.include?('ip')
      ip = yamldata['ip']
    else
      ip = 'localhost'
    end

    if yamldata.include?('port')
      port = yamldata['port']
    else
      port = '3081'
    end

    result = { 
      :ip   => ip, 
      :port => port,
    }

    result
  end
  
#  def self.userLookupByName(name)
#    rest = get_rest_info    
#    rest[:users].key(name)
#  end

#  def self.userLookupById(id)
#    rest = get_rest_info    
#    rest[:users][id]
#  end        

  def exists?    
    @property_hash[:ensure] == :present
  end
  
  def create
    @property_flush[:ensure] = :present
  end

  def destroy        
    @property_flush[:ensure] = :absent
  end
          
  def self.prefetch(resources)        
    instances.each do |prov|
      if resource = resources[prov.name]
       resource.provider = prov
      end
    end
  end  
   
  def self.get_objects(endpoint, resultName = nil)    
    Puppet.debug "FLAPJACK-API (generic) get_objects: #{endpoint}"
    
    response = http_get(endpoint)
      
    Puppet.debug("Call to #{endpoint} on FLAPJACK API returned #{response}")

    if resultName == nil
      response      
    else 
      response[resultName]      
    end
  end
  
  def self.http_get(endpoint) 
    http_generic('GET', endpoint)
  end

  def self.http_post(endpoint, data = {}) 
    http_generic('POST', endpoint, data.to_json)
  end
  
  def self.http_patch(endpoint, data = {}) 
    http_generic('PATCH', endpoint, data.to_json, false)
  end
  
  def self.http_delete(endpoint) 
    http_generic('DELETE', endpoint, {}, false)
  end
  
  def self.http_generic(method, endpoint, data = {}, jsonResult = true) 
    Puppet.debug "FLAPJACK-API (http_generic) #{method}: #{endpoint}"
    
    resource = createResource(endpoint)
        
    begin
      case method
      when 'GET'
        response = resource.get    
            # Accept: application/vnd.api+json
      when 'POST'        
        response = resource.post data, :content_type => :json
            # Accept: application/vnd.api+json
      when 'PATCH'
        response = resource.patch data, :content_type => 'application/json-patch+json'
            # Accept: application/vnd.api+json
      when 'DELETE'
        response = resource.delete 
      else
        raise "FLAPJACK-API - Invalid Method: #{method}"
      end
    rescue => e
      Puppet.debug "FLAPJACK API response: "+e.inspect
      raise "Unable to contact FLAPJACK API on #{resource.url}: #{e.response}"
    end
  
    if jsonResult 
      begin
        responseJson = JSON.parse(response)
      rescue
        raise "Could not parse the JSON response from FLAPJACK API: #{response}"
      end
    else
      responseJson = response
    end
    
    responseJson
  end
    
  def self.createResource(endpoint)
    rest = get_rest_info
    #Puppet.debug "FLAPJACK-API REST INFO: #{rest.inspect}"
    
    url = "http://#{rest[:ip]}:#{rest[:port]}/#{endpoint}"
    
    #resource = RestClient::Resource.new(url, :user => rest[:username], :password => rest[:password])
    resource = RestClient::Resource.new(url)
    
    resource
  end
  
  def self.genericLookup(endpoint, lookupVar, lookupVal, returnVar)
    list = get_objects(endpoint)
           
    if list != nil
      list.each do |object|
        if object[lookupVar] == lookupVal
          return object[returnVar]
        end        
      end
    end
  
    raise "Could not find "+endpoint+" where "+lookupVar+" = "+lookupVal.to_s
  end  
end