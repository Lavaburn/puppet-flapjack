# [*enabled*]
#  enable notifier. Default: yes
# [*notifier_queue*]
#  notifier queue. Default: notifications
# [*log_file*]
#  notification log file. Default: /var/log/flapjack/notification.log
# [*default_contact_timezone*]
#  Default: UTC
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::notifier (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled                   = true,
  $notifier_queue            = 'notifications',
  $log_dir                   = '/var/log/flapjack',
  $log_file                  = 'notification.log',
  $default_contact_timezone  = 'UTC',
  $log_level                 = 'INFO',
  $syslog_errors             = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Notifier
  $title_prefix = "flapjack_${environment}_notifier"
  $key_prefix = "${environment}/notifier"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $notifier_queue,
  }

  yaml_setting { "${title_prefix}_notification_log_file":
    key    => "${key_prefix}/notification_log_file",
    value  => "${log_dir}/${log_file}",
  }

  yaml_setting { "${title_prefix}_default_contact_timezone":
    key    => "${key_prefix}/default_contact_timezone",
    value  => $default_contact_timezone,
  }

  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Notifier[$name] ~> Service['flapjack']
  }
}

