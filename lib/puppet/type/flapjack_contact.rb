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
  end  
end