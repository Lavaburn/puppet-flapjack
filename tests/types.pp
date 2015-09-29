# Custom Type: Flapjack - Contact
flapjack_contact { 'nicolas':
  ensure       => present,
  first_name   => 'Nicolas',
  last_name    => 'Truyens',
  email        => 'nicolas@rcs-communication.com',
  timezone     => 'CET',
  #contact_tags => ['management', 'technical', 'servers'],
}

#flapjack_media { 'nicolas_sms':
#  ensure           =>  absent,
#  contact          => 'nicolas',
#  type             => 'sms',
#  address          => '32478610159',
#  interval         => 60,   # integer
#  rollup_threshold => 120,  # integer
#}

flapjack_media { 'nicolas_email':
  ensure           =>  present,
  contact          => 'nicolas',
  type             => 'email',
  address          => 'nicolas@rcs-communication.com',
  interval         => 60,   # integer
  rollup_threshold => 120,  # integer
}

flapjack_notification_rule { 'nicolas_priority':
  ensure             =>  present,
  contact            => 'nicolas',
  entities           => ['ANY'],
#  regex_entities     => ['network\..*\.core\.twr.*'],
  tags               => ['priority'],
#  regex_tags         => [],
#  time_restrictions  => [],
  unknown_media      => ['email', 'jabber'],
  warning_media      => ['email', 'jabber'],
  critical_media     => ['email', 'jabber'],
#  unknown_blackhole  => false,
#  warning_blackhole  => false,
#  critical_blackhole => false,
}
