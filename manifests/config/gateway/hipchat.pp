# == Definition: flapjack::config::gateway::hipchat
#
# This definition changes Flapjack configuration:
# - Gateway: Hipchat (Room Notifications)
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Twilio SMS Gateway. Default: true
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
  $auth_token,
  $format = 'text',

  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled       = true,
  $queue         = 'hipchat_notifications',

  $templates     = undef,

  # Logging
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_string($queue, $auth_token, $format, $log_level)
  validate_bool($enabled, $syslog_errors)

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
