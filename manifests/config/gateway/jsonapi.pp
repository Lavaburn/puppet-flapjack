# == Definition: flapjack::config::gateway::jsonapi
#
# This definition changes Flapjack configuration:
# - Gateway: JSON API
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the JSON API interface. Default: true
# * port (integer): Port on which the JSON API is listening. Default: 3081
# * timeout (integer): Timeout in seconds. Default: 300
# * base_url (string): JSON API URL (needs to be reachable from browser). Default: http://localhost:3081/
# * log_dir (string): Logging directory. Default: /var/log/flapjack
# * access_log (string): Access log file. Default: jsonapi_access.log
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::jsonapi (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled         = true,
  $port            = 3081,
  $timeout         = 300,
  $base_url        = 'http://localhost:3081/',

  # Logging
  $log_dir         = '/var/log/flapjack',
  $access_log      = 'jsonapi_access.log',

  $log_level       = 'INFO',
  $syslog_errors   = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_absolute_path($log_dir)
  validate_string($base_url, $access_log, $log_level)
  validate_bool($enabled, $syslog_errors)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # JSON API Gateway
  $title_prefix = "flapjack_${name}_gateways_jsonapi"
  $key_prefix = "${environment}/gateways/jsonapi"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_port":
    key   => "${key_prefix}/port",
    value => $port,
  }

  yaml_setting { "${title_prefix}_timeout":
    key   => "${key_prefix}/timeout",
    value => $timeout,
  }

  yaml_setting { "${title_prefix}_access_log":
    key   => "${key_prefix}/access_log",
    value => "${log_dir}/${access_log}",
  }

  yaml_setting { "${title_prefix}_base_url":
    key   => "${key_prefix}/base_url",
    value => $base_url,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Jsonapi[$name] ~> Service['flapjack']
  }
}
