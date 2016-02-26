# == Definition: flapjack::config::processor
#
# This definition changes Flapjack configuration:
# - Processor Config
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to process events on the events queue. Default: true
# * processor_queue (string): Name of the events queue. Default: events
# * notifier_queue (string): Name of the notification queue that is posted to by processor. Default: notifications
# * archive_events (boolean): Whether to archive events. Default: true
# * events_archive_maxage (string): Maximum age (seconds) that events are archived. Default: 10800
# * new_check_scheduled_maintenance_duration (string): The duration that new events (not yet seen) will be put into maintenance. Default: 100 years
# * new_check_scheduled_maintenance_ignore_tags (array): The tags that will not be automatically added to maintenance mode. Default: ["bypass_ncsm"]
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::processor (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled         = true,
  $processor_queue = 'events',
  $notifier_queue  = 'notifications',

  $archive_events        = true,
  $events_archive_maxage = 10800, # 3 Hours

  $new_check_scheduled_maintenance_duration    = '100 years',
  $new_check_scheduled_maintenance_ignore_tags = [ 'bypass_ncsm' ],

  # Logging
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_string($processor_queue, $notifier_queue, $log_level)
  validate_string($new_check_scheduled_maintenance_duration)
  validate_array($new_check_scheduled_maintenance_ignore_tags)
  validate_bool($enabled, $archive_events, $syslog_errors)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Processor
  $title_prefix = "flapjack_${name}_processor"
  $key_prefix = "${environment}/processor"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $processor_queue,
  }

  yaml_setting { "${title_prefix}_notifier_queue":
    key   => "${key_prefix}/notifier_queue",
    value => $notifier_queue,
  }

  yaml_setting { "${title_prefix}_archive_events":
    key   => "${key_prefix}/archive_events",
    value => $archive_events,
  }

  yaml_setting { "${title_prefix}_events_archive_maxage":
    key   => "${key_prefix}/events_archive_maxage",
    value => $events_archive_maxage,
  }

  yaml_setting { "${title_prefix}_new_check_scheduled_maintenance_duration":
    key   => "${key_prefix}/new_check_scheduled_maintenance_duration",
    value => $new_check_scheduled_maintenance_duration,
  }

  yaml_setting { "${title_prefix}_new_check_scheduled_maintenance_ignore_tags":
    key   => "${key_prefix}/new_check_scheduled_maintenance_ignore_tags",
    value => $new_check_scheduled_maintenance_ignore_tags,
    type  => 'array',
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Flapjack::Config::Processor[$name] ~> Service[$flapjack::service_name]
  }

  # Ordering
  Package[$flapjack::package_name] -> Flapjack::Config::Processor[$name]
}
