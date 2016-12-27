# Custom Type: Flapjack - Entity

Puppet::Type.newtype(:flapjack_entity) do
  @doc = "Flapjack Entity"
  
  ensurable
  
  newparam(:id, :namevar => true) do
    desc "Entity ID"
  end

  newproperty(:name) do
    desc "Entity Name"
  end
  
  newproperty(:entity_tags, :array_matching => :all) do
    desc "Entity Tags"

    def insync?(is)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end    
  end
end