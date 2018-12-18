# == Definition: flapjack::config::gateway::oobetet
#
# This definition changes Flapjack configuration:
# - Gateway: OOBETET
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Twilio SMS Gateway. Default: true
# * server (string): Jabber Server name. Default: jabber.example.com
# * port (integer): Jabber Server port. Default: 5222
# * id (string): Jabber Username. Default: flapjacktest@jabber.example.com
# * password (string): Jabber Password. Default: nuther-good-password
# * oobetet_alias (string): Jabber Alias. Default: flapjacktest
# * watched_check (string): Check to watch. Default: "PING"
# * watched_entity (string): Entity to watch. Default: "foo.example.com"
# * max_latency (integer): Maximum latency (?) Default: 300
# * pagerduty_contact (string): Pagerduty contact to notify. Default: "11111111111111111111111111111111"
# * rooms (array): Public Rooms to connect to. Default: ["flapjacktest@conference.jabber.example.com"]
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::oobetet (
  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,

  # Jabber Server
  String $server        = 'jabber.example.com',
  Integer $port         = 5222,
  String $id            = 'flapjacktest@jabber.example.com',
  String $password      = 'nuther-good-password',
  String $oobetet_alias = 'flapjacktest',

  String $watched_check  = 'PING',
  String $watched_entity = 'foo.example.com',
  Integer $max_latency   = 300,

  String $pagerduty_contact = '11111111111111111111111111111111',
  Array $rooms              = [ 'flapjacktest@conference.jabber.example.com' ],

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # OOBETET Gateway
  $title_prefix = "flapjack_${name}_gateways_oobetet"
  $key_prefix = "${environment}/gateways/oobetet"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_server":
    key   => "${key_prefix}/server",
    value => $server,
  }

  yaml_setting { "${title_prefix}_port":
    key   => "${key_prefix}/port",
    value => $port,
  }

  yaml_setting { "${title_prefix}_jabberid":
    key   => "${key_prefix}/jabberid",
    value => $id,
  }

  yaml_setting { "${title_prefix}_password":
    key   => "${key_prefix}/password",
    value => $password,
  }

  yaml_setting { "${title_prefix}_alias":
    key   => "${key_prefix}/alias",
    value => $oobetet_alias,
  }

  yaml_setting { "${title_prefix}_watched_check":
    key   => "${key_prefix}/watched_check",
    value => $watched_check,
  }

  yaml_setting { "${title_prefix}_watched_entity":
    key   => "${key_prefix}/watched_entity",
    value => $watched_entity,
  }

  yaml_setting { "${title_prefix}_max_latency":
    key   => "${key_prefix}/max_latency",
    value => $max_latency,
  }

  yaml_setting { "${title_prefix}_pagerduty_contact":
    key   => "${key_prefix}/pagerduty_contact",
    value => $pagerduty_contact,
  }

  yaml_setting { "${title_prefix}_rooms":
    key   => "${key_prefix}/rooms",
    value => $rooms,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Oobetet[$name] ~> Service[$flapjack::service_name]
  }
}
