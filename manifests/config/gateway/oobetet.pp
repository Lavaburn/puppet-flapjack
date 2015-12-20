# [*enabled*]
#  Default: no
# [*server*]
#  Default: jabber.example.com
# [*port*]
#  Default: 5222
# [*id*]
#  Default: flapjacktest@jabber.example.com
# [*password*]
#  Default: nuther-good-password
# [*alias*]
#  Default: flapjacktest
# [*watched_check*]
#  Default: "PING"
# [*watched_entity*]
#  Default: "foo.example.com"
# [*max_latency*]
#  Default: 300
# [*pagerduty_contact*]
# Default: "11111111111111111111111111111111"
# [*rooms*]
#  Default: ["flapjacktest@conference.jabber.example.com"] 
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::oobetet (
  # Common Config 
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',
  
  # Parameters
  $enabled           = 'no',
  $server            = 'jabber.example.com',
  $port              = 5222,
  $id                = 'flapjacktest@jabber.example.com',
  $password          = 'nuther-good-password',
  $alias             = 'flapjacktest',
  $watched_check     = 'PING',
  $watched_entity    = 'foo.example.com',
  $max_latency       = 300,
  $pagerduty_contact = '11111111111111111111111111111111',
  $rooms             = [ 'flapjacktest@conference.jabber.example.com' ],
  $log_level         = INFO,
  $syslog_errors     = yes,
) {
  # Common Config  
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }
  
  # OOBETET Gateway
  $title_prefix = "flapjack_${name}_gateways_oobetet"
  $key_prefix = "${environment}/gateways/oobetet"
  
  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_server":
    key    => "${key_prefix}/server",
    value  => $server,
  }
  
  yaml_setting { "${title_prefix}_port":
    key    => "${key_prefix}/port",
    value  => $port,
  }
  
  yaml_setting { "${title_prefix}_jabberid":
    key    => "${key_prefix}/jabberid",
    value  => $id,
  }

  yaml_setting { "${title_prefix}_password":
    key    => "${key_prefix}/password",
    value  => $password,
  }
  
  yaml_setting { "${title_prefix}_alias":
    key    => "${key_prefix}/alias",
    value  => $alias,
  }

  yaml_setting { "${title_prefix}_watched_check":
    key    => "${key_prefix}/watched_check",
    value  => $watched_check,
  }

  yaml_setting { "${title_prefix}_watched_entity":
    key    => "${key_prefix}/watched_entity",
    value  => $watched_entity,
  }
  
  yaml_setting { "${title_prefix}_max_latency":
    key    => "${key_prefix}/max_latency",
    value  => $max_latency,
  }
  
  yaml_setting { "${title_prefix}_pagerduty_contact":
    key    => "${key_prefix}/pagerduty_contact",
    value  => $pagerduty_contact,
  }

  yaml_setting { "${title_prefix}_rooms":
    key    => "${key_prefix}/rooms",
    value  => $rooms,
  }
    
  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }
}
