# == Definition: flapjack::config::nagios
#
# This definition changes Flapjack configuration:
# - Nagios Config
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * nagios_receiver_fifo (path): Nagios FIFO pipe path. Default: /var/cache/nagios3/event_stream.fifo
# * ncsa_receiver_fifo (path): NCSA FIFO pipe path. Default: /var/lib/nagios3/rw/nagios.cmd
# * pid_dir (path): PID Directory. Default: /var/run/flapjack/
# * log_dir (path): Logging Directory. Default: /var/log/flapjack/
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::nagios (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $nagios_receiver_fifo = '/var/cache/nagios3/event_stream.fifo',
  $ncsa_receiver_fifo   = '/var/lib/nagios3/rw/nagios.cmd',

  $pid_dir              = '/var/run/flapjack/',
  $log_dir              = '/var/log/flapjack/',
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_absolute_path($nagios_receiver_fifo, $ncsa_receiver_fifo)
  validate_absolute_path($pid_dir, $log_dir)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }


  # Nagios
  $title_prefix_nagios = "flapjack_${name}_nagios-receiver"
  $key_prefix_nagios = "${environment}/nagios-receiver"

  yaml_setting { "${title_prefix_nagios}_fifo":
    key   => "${key_prefix_nagios}/fifo",
    value => $nagios_receiver_fifo,
  }

  yaml_setting { "${title_prefix_nagios}_pid_dir":
    key   => "${key_prefix_nagios}/pid_dir",
    value => $pid_dir,
  }

  yaml_setting { "${title_prefix_nagios}_log_dir":
    key   => "${key_prefix_nagios}/log_dir",
    value => $log_dir,
  }


  # NSCA
  $title_prefix_nsca = "flapjack_${name}_nsca-receiver"
  $key_prefix_nsca = "${environment}/nsca-receiver"

  yaml_setting { "${title_prefix_nsca}_fifo":
    key   => "${key_prefix_nsca}/fifo",
    value => $ncsa_receiver_fifo,
  }

  yaml_setting { "${title_prefix_nsca}_pid_dir":
    key   => "${key_prefix_nsca}/pid_dir",
    value => $pid_dir,
  }

  yaml_setting { "${title_prefix_nsca}_log_dir":
    key   => "${key_prefix_nsca}/log_dir",
    value => $log_dir,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Nagios[$name] ~> Service[$flapjack::service_name]
  }
}
