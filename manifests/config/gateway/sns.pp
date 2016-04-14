# == Definition: flapjack::config::gateway::sns
#
# This definition changes Flapjack configuration:
# - Gateway: (Amazon) SNS
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the SNS Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: sns_notifications
# * access_key (string): Amazon SNS API key
# * secret_key (string): Amazon SNS API secret
# * region_name (string): Amazon SNS API region
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::sns (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled       = true,
  $queue         = 'sns_notifications',

  # Amazon SNS
  $access_key    = 'AKIAIOSFODNN7EXAMPLE',
  $secret_key    = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  $region_name   = undef,

  # Logging
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_string($queue, $access_key, $secret_key, $log_level)
  validate_bool($enabled, $syslog_errors)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # SNS Gateway
  $title_prefix = "flapjack_${name}_gateways_sns"
  $key_prefix = "${environment}/gateways/sns"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  yaml_setting { "${title_prefix}_access_key":
    key   => "${key_prefix}/access_key",
    value => $access_key,
  }

  yaml_setting { "${title_prefix}_secret_key":
    key   => "${key_prefix}/secret_key",
    value => $secret_key,
  }

  yaml_setting { "${title_prefix}_region_name":
    key   => "${key_prefix}/region_name",
    value => $region_name,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_sns_queue":
    key   => "${key_prefix_notifier}/sns_queue",
    value => $queue,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Sns[$name] ~> Service[$flapjack::service_name]
  }
}
