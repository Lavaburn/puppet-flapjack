# == Definition: flapjack::config::gateway::hipchat
#
# This definition changes Flapjack configuration:
# - Gateway: Hipchat (Room Notifications)
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Hipchat Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: jabber_notifications
# * auth_token (string): API Authentication Token for Hipchat API v2
# * format (string): Format to use for notifications. Default: 'text'
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::hipchat (
  # Hipchat API
  String $auth_token,
  String $format      = 'text',

  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'hipchat_notifications',

  Optional[Hash] $templates = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Hipchat Gateway
  $title_prefix = "flapjack_${name}_gateways_hipchat"
  $key_prefix = "${environment}/gateways/hipchat"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  yaml_setting { "${title_prefix}_auth_token":
    key   => "${key_prefix}/auth_token",
    value => $auth_token,
  }

  yaml_setting { "${title_prefix}_format":
    key   => "${key_prefix}/format",
    value => $format,
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

  yaml_setting { "${title_prefix_notifier}_hipchat_queue":
    key   => "${key_prefix_notifier}/hipchat_queue",
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
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Hipchat[$name] ~> Service[$flapjack::service_name]
  }
}
