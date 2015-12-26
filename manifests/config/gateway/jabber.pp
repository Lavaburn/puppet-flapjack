# [*enabled*]
#  Default: no
# [*queue*]
#  Default: jabber_notifications
# [*server*]
#  Default: jabber.example.com
# [*port*]
#  Default: 5222
# [*id*]
#  Default: flapjack@jabber.example.com
# [*password*]
#  Default: good-password
# [*jabber_alias*]
#  Default: flapjack
# [*identifiers*]
#  Default: ["@flapjack"]
# [*rooms*]
#  Default: ["gimp@conference.jabber.example.com"]
# [*templates*]
#  Default: undef
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::jabber (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled       = true,
  $queue         = 'jabber_notifications',
  $server        = 'jabber.example.com',
  $port          = 5222,
  $id            = 'flapjack@jabber.example.com',
  $password      = 'good-password',
  $jabber_alias  = 'flapjack',
  $identifiers   = [ '@flapjack' ],
  $rooms         = [ 'gimp@conference.jabber.example.com' ],
  $templates     = undef,
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Jabber Gateway
  $title_prefix = "flapjack_${name}_gateways_jabber"
  $key_prefix = "${environment}/gateways/jabber"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $queue,
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
    value  => $jabber_alias,
  }

  yaml_setting { "${title_prefix}_identifiers":
    key    => "${key_prefix}/identifiers",
    value  => $identifiers,
    type   => 'array',
  }

  yaml_setting { "${title_prefix}_rooms":
    key    => "${key_prefix}/rooms",
    value  => $rooms,
    type   => 'array',
  }

  # Templates
    # HASH: eg.
    #   rollup.text: '/etc/flapjack/templates/jabber/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/jabber/alert.text.erb'
  if ($templates != undef) {
	  yaml_setting { "${title_prefix}_templates":
	    key    => "${key_prefix}/templates",
	    value  => $templates,
	  }
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_jabber_queue":
    key    => "${key_prefix_notifier}/jabber_queue",
    value  => $queue,
  }

  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Gateway::Jabber[$name] ~> Service['flapjack']
  }
}
