# Custom Type: Flapjack - Contact

Puppet::Type.newtype(:flapjack_contact) do
  @doc = "Flapjack Contact"
  
  ensurable
  
  newparam(:name, :namevar => true) do    # id
    desc "The contact name"
  end

  newproperty(:first_name) do
    desc "Contact First Name"
  end

  newproperty(:last_name) do
    desc "Contact Last Name"
  end
  
  newproperty(:email) do
    desc "Contact E-Mail Address"
  end
  
  newproperty(:timezone) do
    desc "Contact Timezone"
  end
  
#  newproperty(:contact_tags, :array_matching => :all) do
#    desc "Contact Tags"
#  end
  
  newproperty(:linked_entities, :array_matching => :all) do
    desc "Linked Entities"

    def insync?(is)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:default_rule_blackholes, :array_matching => :all) do
    desc "Blackholes for the default notification rule that is created per contact (unknown,critical,warning)"

    def insync?(is)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end  
end