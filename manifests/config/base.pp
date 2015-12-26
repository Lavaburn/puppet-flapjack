# [*pid_dir*]
#   pid directory. Default: /var/run/flapjack/
# [*log_dir*]
#   log directory. Default: /var/log/flapjack/
# [*log_level*]
#   log level. Default: INFO
# [*syslog_errors*]
#   send errors to syslog??. Default: yes
define flapjack::config::base (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $pid_dir       = '/var/run/flapjack/',
  $log_dir       = '/var/log/flapjack/',
  $log_level     = 'INFO',
  $syslog_errors = true,

  $owner = 'flapjack',
  $group = 'flapjack',
  $mode  = '0775',
) {
  # Common Config
  ensure_resource('file', $config_dir, {'ensure' => 'directory', owner => $owner, group => $group, mode => $mode })
  ensure_resource('file', "${config_dir}/${config_file}", {'ensure' => 'file', owner => $owner, group => $group, mode => '0644' })
  ensure_resource('file', $pid_dir, {'ensure' => 'directory', owner => $owner, group => $group, mode => $mode })
  ensure_resource('file', $log_dir, {'ensure' => 'directory', owner => $owner, group => $group, mode => $mode })

  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Base
  $title_prefix = "flapjack_${name}_base"
  $key_prefix = "${environment}"

  File[$config_dir] ->
  yaml_setting { "${title_prefix}_pid_dir":
    key    => "${key_prefix}/pid_dir",
    value  => $pid_dir,
  }

  File[$config_dir] ->
  yaml_setting { "${title_prefix}_log_dir":
    key    => "${key_prefix}/log_dir",
    value  => $log_dir,
  }

  File[$config_dir] ->
  yaml_setting { "${title_prefix}_daemonize":
    key    => "${key_prefix}/daemonize",
    value  => true,
  }

  File[$config_dir] ->
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Base[$name] ~> Service['flapjack']
  }
}
