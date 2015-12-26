# [*enabled*]
#  Default: no
# [*queue*]
#  Default: sns_notifications
# [*access_key*]
#  Default: 'AKIAIOSFODNN7EXAMPLE'
# [*secret_key*]
#  Default: 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
# [*region_name*]
#  Default: undef
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::sns (
  # Common Config
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',

  # Parameters
  $enabled       = true,
  $queue         = 'sns_notifications',
  $access_key    = 'AKIAIOSFODNN7EXAMPLE',
  $secret_key    = 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
  $region_name   = undef,
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Common Config
  File[$config_dir] ->
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # SNS Gateway
  $title_prefix = "flapjack_${name}_gateways_sns"
  $key_prefix = "${environment}/gateways/sns"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $queue,
  }

  yaml_setting { "${title_prefix}_access_key":
    key    => "${key_prefix}/access_key",
    value  => $access_key,
  }

  yaml_setting { "${title_prefix}_secret_key":
    key    => "${key_prefix}/secret_key",
    value  => $secret_key,
  }

  yaml_setting { "${title_prefix}_region_name":
    key    => "${key_prefix}/region_name",
    value  => $region_name,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_sns_queue":
    key    => "${key_prefix_notifier}/sns_queue",
    value  => $queue,
  }

  if ($refresh_service) {
    Flapjack::Config::Gateway::Sns[$name] ~> Service['flapjack']
  }
}
