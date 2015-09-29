# Custom Type: Flapjack - Media

Puppet::Type.newtype(:flapjack_media) do
  @doc = "Flapjack Media"
  
  ensurable
  
  newparam(:name, :namevar => true) do    # id
    desc "The media ID (contactId_mediaType)"
  end
  
  newproperty(:contact) do
    desc "Contact ID that the media is linked to"
  end
  

  newproperty(:type) do
    desc "Media Type (email/sms/jabber)"
    # newvalues
  end
  
  newproperty(:address) do
    desc "Media Address"
  end
  
  newproperty(:interval) do
    desc "Media Interval"
  end
  
  newproperty(:rollup_threshold) do
    desc "Media Rollup Threshold"
  end
end