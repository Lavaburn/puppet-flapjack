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
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  Integer $port    = 3081,
  Integer $timeout = 300,
  String $base_url = 'http://localhost:3081/',

  # Logging
  String $log_dir    = '/var/log/flapjack',
  String $access_log = 'jsonapi_access.log',

  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
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
