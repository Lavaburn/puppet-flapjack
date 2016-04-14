# == Definition: flapjack::config::notifier
#
# This definition changes Flapjack configuration:
# - Notifier Config
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to process events on the notification queue. Default: true
# * notifier_queue (string): Name of the notification queue that is read from. Default: notifications
#
# * log_dir (string): The directory for the logfile. Default: /var/log/flapjack
# * log_file (string): The logfile. Default: notification.log
# * default_contact_timezone (string): The default timezone for new contacts. Default: UTC
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::notifier (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled                  = true,
  $notifier_queue           = 'notifications',
  $log_dir                  = '/var/log/flapjack',
  $log_file                 = 'notification.log',
  $default_contact_timezone = 'UTC',

  # Logging
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_absolute_path($log_dir)
  validate_string($notifier_queue, $log_file, $log_level)
  validate_string($default_contact_timezone)
  validate_bool($enabled, $syslog_errors)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }


  # Notifier
  $title_prefix = "flapjack_${name}_notifier"
  $key_prefix = "${environment}/notifier"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $notifier_queue,
  }

  yaml_setting { "${title_prefix}_notification_log_file":
    key   => "${key_prefix}/notification_log_file",
    value => "${log_dir}/${log_file}",
  }

  yaml_setting { "${title_prefix}_default_contact_timezone":
    key   => "${key_prefix}/default_contact_timezone",
    value => $default_contact_timezone,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Notifier[$name] ~> Service[$flapjack::service_name]
  }
}

