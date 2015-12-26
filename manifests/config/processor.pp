# [*enabled*]
#   Processes monitoring events off the *events* queue. Default: yes
# [*processor_queue*]
#   *events* queue. Default: events
# [*notifier_queue*]
#   *notifications* queue. Default: notifications
# [*archive_events*]
#   archive events. Default: true
# [*events_archive_maxage*]
#  Default: 10800
# [*new_check_scheduled_maintenance_duration*]
#  Default: 100 years
# [*new_check_scheduled_maintenance_ignore_tags*]
#  Default: - bypass_ncsm
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: true
define flapjack::config::processor (
  # Common Config
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',
  $refresh_service = true,

  # Parameters
  $enabled                                     = 'yes',
  $processor_queue                             = 'events',
  $notifier_queue                              = 'notifications',
  $archive_events                              = true,
  $events_archive_maxage                       = 10800, # 3 Hours
  $new_check_scheduled_maintenance_duration    = '100 years',
  $new_check_scheduled_maintenance_ignore_tags = [ 'bypass_ncsm' ],
  $log_level                                   = 'INFO',
  $syslog_errors                               = 'yes',
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Processor
  $title_prefix = "flapjack_${name}_processor"
  $key_prefix = "${environment}/processor"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $processor_queue,
  }

  yaml_setting { "${title_prefix}_notifier_queue":
    key    => "${key_prefix}/notifier_queue",
    value  => $notifier_queue,
  }

  yaml_setting { "${title_prefix}_archive_events":
    key    => "${key_prefix}/archive_events",
    value  => $archive_events,
  }

  yaml_setting { "${title_prefix}_events_archive_maxage":
    key    => "${key_prefix}/events_archive_maxage",
    value  => $events_archive_maxage,
  }

  yaml_setting { "${title_prefix}_new_check_scheduled_maintenance_duration":
    key    => "${key_prefix}/new_check_scheduled_maintenance_duration",
    value  => $new_check_scheduled_maintenance_duration,
  }

  yaml_setting { "${title_prefix}_new_check_scheduled_maintenance_ignore_tags":
    key    => "${key_prefix}/new_check_scheduled_maintenance_ignore_tags",
    value  => $new_check_scheduled_maintenance_ignore_tags,
  }

  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Processor[$name] ~> Service['flapjack']
  }
}
