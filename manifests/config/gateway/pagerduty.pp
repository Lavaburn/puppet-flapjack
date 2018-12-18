# == Definition: flapjack::config::gateway::pagerduty
#
# This definition changes Flapjack configuration:
# - Gateway: Pagerduty
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Pagerduty Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: pagerduty_notifications
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::pagerduty (
  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'pagerduty_notifications',

  Optional[Hash] $templates = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Pagerduty Gateway
  $title_prefix = "flapjack_${name}_gateways_pagerduty"
  $key_prefix = "${environment}/gateways/pagerduty"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  # Templates
    # HASH: eg.
    #  alert.text: '/etc/flapjack/templates/pagerduty/alert.text.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_pagerduty_queue":
    key   => "${key_prefix_notifier}/pagerduty_queue",
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
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Pagerduty[$name] ~> Service[$flapjack::service_name]
  }
}
