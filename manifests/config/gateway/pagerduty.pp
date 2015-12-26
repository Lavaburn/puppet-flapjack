# [*enabled*]
#  Default: no
# [*queue*]
#  Default: pagerduty_notifications
# [*templates*]
#  Default: undef
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::pagerduty (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled       = true,
  $queue         = 'pagerduty_notifications',
  $templates     = undef,
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Pagerduty Gateway
  $title_prefix = "flapjack_${name}_gateways_pagerduty"
  $key_prefix = "${environment}/gateways/pagerduty"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $queue,
  }

  # Templates
    # HASH: eg.
    #  alert.text: '/etc/flapjack/templates/pagerduty/alert.text.erb'
  if ($templates != undef) {
    yaml_setting { "${title_prefix}_templates":
      key    => "${key_prefix}/templates",
      value  => $templates,
    }
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_pagerduty_queue":
    key    => "${key_prefix_notifier}/pagerduty_queue",
    value  => $queue,
  }

  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Gateway::Pagerduty[$name] ~> Service['flapjack']
  }
}
