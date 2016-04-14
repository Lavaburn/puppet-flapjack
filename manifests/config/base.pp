# == Definition: flapjack::config::base
#
# This definition sets up the configuration directory and file
# and changes Flapjack configuration:
# - Base Config (pid and log dir)
#
# === Common Parameters:
# * config_dir (path): The directory containing the configuration file(s). Default: /etc/flapjack
# * config_file (string): The name of the configuration file. Default: flapjack_config.yaml
# * environment (string): The name of the environment that is being set up. Default: production
# * refresh_service (boolean): Whether to refresh the service after configuration change. Default: true
#
# * log_level (string): The loglevel for this part of the configuration. Default: INFO
# * syslog_errors (boolean): Whether to log errors to syslog. Default: true
#
# === Parameters:
# * owner (string): The owner of the directories managed. Default: flapjack
# * group (string): The group of the directories managed. Default: flapjack
# * mode (string): The mode to set the directories managed. Default: 0775
# * manage_config (boolean): Whether to manage the configuration directory/file. Default: true
#
# * pid_dir (path): Path to the PID directory. Default: /var/run/flapjack/
# * manage_pid_dir (boolean): Whether to manage the pid directory. Default: true
# * log_dir (path): Path to the logs directory. Default: /var/log/flapjack/
# * manage_log_dir (boolean): Whether to manage the log directory. Default: true
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::base (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Directory Management
  $owner          = 'flapjack',
  $group          = 'flapjack',
  $mode           = '0775',
  $manage_config  = true,

  $pid_dir        = '/var/run/flapjack/',
  $manage_pid_dir = true,

  $log_dir        = '/var/log/flapjack/',
  $manage_log_dir = true,

  # Logging
  $log_level      = 'INFO',
  $syslog_errors  = true,
) {
  # Validation
  validate_absolute_path($config_dir, $pid_dir, $log_dir)
  validate_string($config_file, $environment, $owner, $group, $mode)
  validate_bool($refresh_service, $manage_config, $manage_pid_dir, $manage_log_dir)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }


  # Configuration
  if ($manage_config) {
    file { $config_dir:
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }
    ->
    file { "${config_dir}/${config_file}":
      ensure => 'file',
      owner  => $owner,
      group  => $group,
      mode   => '0644',
    }
  }


  # Base
  $title_prefix = "flapjack_${name}_base"
  $key_prefix = $environment

  yaml_setting { "${title_prefix}_pid_dir":
    key   => "${key_prefix}/pid_dir",
    value => $pid_dir,
  }

  if ($manage_pid_dir) {
    file { $pid_dir:
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }
  }

  yaml_setting { "${title_prefix}_log_dir":
    key   => "${key_prefix}/log_dir",
    value => $log_dir,
  }

  if ($manage_log_dir) {
    file { $log_dir:
      ensure => 'directory',
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }
  }

  yaml_setting { "${title_prefix}_daemonize":
    key   => "${key_prefix}/daemonize",
    value => true,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Base[$name] ~> Service[$flapjack::service_name]
  }
}
