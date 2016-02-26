# == Definition: flapjack::config::redis
#
# This definition changes Flapjack configuration:
# - Redis Config
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * host (string): Redis hostname. Default: 127.0.0.1
# * port (integer): Redis port. Default: 6380    # TODO
# * password (false or string): Redis password. Default: false (no password)
# * db (integer): database ID. Default: 0
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::redis (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $host     = '127.0.0.1',
  $port     = 6380,
  $password = false,
  $db       = 0,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_string($host)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }


  # Redis
  $title_prefix = "flapjack_${name}_redis"
  $key_prefix = "${environment}/redis"

  yaml_setting { "${title_prefix}_host":
    key   => "${key_prefix}/host",
    value => $host,
  }

  yaml_setting { "${title_prefix}_port":
    key   => "${key_prefix}/port",
    value => $port,
  }

  if ($password != false and $password != undef) {
    yaml_setting { "${title_prefix}_password":
      key   => "${key_prefix}/password",
      value => $password,
    }
  } else {
    yaml_setting { "${title_prefix}_password":
      ensure => 'absent',
      key    => "${key_prefix}/password",
    }
  }

  yaml_setting { "${title_prefix}_db":
    key   => "${key_prefix}/db",
    value => $db,
  }

  # Restart Service
  if ($refresh_service) {
    Flapjack::Config::Redis[$name] ~> Service[$flapjack::service_name]
  }

  # Ordering
  Package[$flapjack::package_name] -> Flapjack::Config::Redis[$name]
}
