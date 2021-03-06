# == Definition: flapjack::config::gateway::jabber
#
# This definition changes Flapjack configuration:
# - Gateway: Jabber XMPP
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Twilio SMS Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: jabber_notifications
# * server (string): Jabber Server name. Default: jabber.example.com
# * port (integer): Jabber Server port. Default: 5222
# * id (string): Jabber Username. Default: flapjack@jabber.example.com
# * password (string): Jabber Password. Default: good-password
# * jabber_alias (string): Jabber Alias. Default: flapjack
# * identifiers (array): Jabber aliases to respond to. Default: ["@flapjack"]
# * rooms (array): Public rooms to join. Default: ["gimp@conference.jabber.example.com"]
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::jabber (
  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'jabber_notifications',

  # Jabber XMPP
  String $server       = 'jabber.example.com',
  Integer $port        = 5222,
  String $id           = 'flapjack@jabber.example.com',
  String $password     = 'good-password',
  String $jabber_alias = 'flapjack',
  Array $identifiers   = [ '@flapjack' ],
  Array $rooms         = [ 'gimp@conference.jabber.example.com' ],

  Optional[Hash] $templates = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Jabber Gateway
  $title_prefix = "flapjack_${name}_gateways_jabber"
  $key_prefix = "${environment}/gateways/jabber"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
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
    value => $jabber_alias,
  }

  yaml_setting { "${title_prefix}_identifiers":
    key   => "${key_prefix}/identifiers",
    value => $identifiers,
    type  => 'array',
  }

  yaml_setting { "${title_prefix}_rooms":
    key   => "${key_prefix}/rooms",
    value => $rooms,
    type  => 'array',
  }

  # Templates
    # HASH: eg.
    #   rollup.text: '/etc/flapjack/templates/jabber/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/jabber/alert.text.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_jabber_queue":
    key   => "${key_prefix_notifier}/jabber_queue",
    value => $queue,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Jabber[$name] ~> Service[$flapjack::service_name]
  }
}
