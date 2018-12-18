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
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'sns_notifications',

  # Amazon SNS
  String $access_key            = 'AKIAIOSFODNN7EXAMPLE',
  String $secret_key            = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  Optional[String] $region_name = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
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
