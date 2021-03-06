# == Definition: flapjack::config::gateway::web
#
# This definition changes Flapjack configuration:
# - Gateway: Web
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the web interface. Default: true
# * port (integer): Port on which the webinterface is listening. Default: 3080
# * timeout (integer): Timeout in seconds. Default: 300
# * auto_refresh (boolean): Auto refresh time in seconds. Default: 120
# * api_url (string): JSON API URL (needs to be reachable from browser). Default: http://localhost:3081/
# * logo_image_path (string): Path to custom logos? Default: undef
# * log_dir (string): Logging directory. Default: /var/log/flapjack
# * access_log (string): Access log file. Default: web_access.log
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::web (
  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled                  = true,
  Integer $port                     = 3080,
  Integer $timeout                  = 300,
  Integer $auto_refresh             = 120,
  String $api_url                   = 'http://localhost:3081/',
  Optional[String] $logo_image_path = undef,

  # Logging
  String $log_dir    = '/var/log/flapjack',
  String $access_log = 'web_access.log',

  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Web Gateway
  $title_prefix = "flapjack_${name}_gateways_web"
  $key_prefix = "${environment}/gateways/web"

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

  yaml_setting { "${title_prefix}_auto_refresh":
    key   => "${key_prefix}/auto_refresh",
    value => $auto_refresh,
  }

  yaml_setting { "${title_prefix}_access_log":
    key   => "${key_prefix}/access_log",
    value => "${log_dir}/${access_log}",
  }

  yaml_setting { "${title_prefix}_api_url":
    key   => "${key_prefix}/api_url",
    value => $api_url,
  }

  if ($logo_image_path != undef) {
    yaml_setting { "${title_prefix}_logo_image_path":
      key   => "${key_prefix}/logo_image_path",
      value => $logo_image_path,
    }
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Web[$name] ~> Service['flapjack']
  }
}
