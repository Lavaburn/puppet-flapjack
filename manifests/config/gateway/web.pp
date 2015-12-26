# [*enabled*]
#  Default: yes
# [*port*]
#  Default: 3080
# [*timeout*]
#  Default: 300
# [*auto_refresh*]
#  Seconds between auto_refresh of entities/checks pages.  Set to 0 to disable. Default 120
# [*log_dir*]
#  Default: "/var/log/flapjack"
# [*access_log*]
#  Default: "web_access.log"
# [*api_url*]
#  Default: "http://localhost:3081/"
# [*logo_image_path*]
#  Default: undef
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::web (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled         = 'yes',
  $port            = 3080,
  $timeout         = 300,
  $auto_refresh    = 120,
  $log_dir         = '/var/log/flapjack',
  $access_log      = 'web_access.log',
  $api_url         = "http://localhost:3081/",
  $logo_image_path = undef,
  $log_level       = 'INFO',
  $syslog_errors   = yes,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Web Gateway
  $title_prefix = "flapjack_${name}_gateways_web"
  $key_prefix = "${environment}/gateways/web"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_port":
    key    => "${key_prefix}/port",
    value  => $port,
  }

  yaml_setting { "${title_prefix}_timeout":
    key    => "${key_prefix}/timeout",
    value  => $timeout,
  }

  yaml_setting { "${title_prefix}_auto_refresh":
    key    => "${key_prefix}/auto_refresh",
    value  => $auto_refresh,
  }

  yaml_setting { "${title_prefix}_access_log":
    key    => "${key_prefix}/access_log",
    value  => "${log_dir}/${access_log}",
  }

  yaml_setting { "${title_prefix}_api_url":
    key    => "${key_prefix}/api_url",
    value  => $api_url,
  }

  if ($logo_image_path != undef) {
	  yaml_setting { "${title_prefix}_logo_image_path":
	    key    => "${key_prefix}/logo_image_path",
	    value  => $logo_image_path,
	  }
	}

  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Gateway::Web[$name] ~> Service['flapjack']
  }
}
