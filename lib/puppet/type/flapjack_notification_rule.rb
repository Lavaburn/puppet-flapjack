# Custom Type: Flapjack - Notification Rule

Puppet::Type.newtype(:flapjack_notification_rule) do
  @doc = "Flapjack Notification Rule"
  
  ensurable
  
  newparam(:name, :namevar => true) do  # id
    desc "The notification rule name (ID)"
  end
  
  newproperty(:contact) do
    desc "Contact ID that the notification rule is linked to"
  end
    
  newproperty(:entities, :array_matching => :all) do
    desc "The entities linked to the rule"
    defaultto Array.new
  end
  
  newproperty(:regex_entities, :array_matching => :all) do
    desc "The regular expression grouping entities linked to the rule"
    defaultto Array.new
  end
  
  newproperty(:tags, :array_matching => :all) do
    desc "The tags linked to the rule"
    defaultto Array.new
  end
  
  newproperty(:regex_tags, :array_matching => :all) do
    desc "The regular expression grouping tags linked to the rule"
    defaultto Array.new
  end
  
  newproperty(:time_restrictions, :array_matching => :all) do
    desc "Time restrictions applied to this rule"
    defaultto Array.new
  end
  
  newproperty(:unknown_media, :array_matching => :all) do
    desc "Media that can be used for Unknown State"
    defaultto Array.new
  end
  
  newproperty(:warning_media, :array_matching => :all) do
    desc "Media that can be used for Warning State"
    defaultto Array.new
  end
  
  newproperty(:critical_media, :array_matching => :all) do
    desc "Media that can be used for Critical State"
    defaultto Array.new
  end
  
  newproperty(:unknown_blackhole) do
    desc "Whether to remove alerts in Unknown State"
    newvalues(true, false)
    defaultto false
  end
  
  newproperty(:warning_blackhole) do
    desc "Whether to remove alerts in Warning State"
    newvalues(true, false)
    defaultto false
  end
  
  newproperty(:critical_blackhole) do
    desc "Whether to remove alerts in Critical State"
    newvalues(true, false)
    defaultto false
  end
end