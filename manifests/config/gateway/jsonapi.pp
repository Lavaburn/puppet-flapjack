# [*enabled*]
#  Default: yes
# [*port*]
#  Default: 
# [*timeout*]
#  Default: 300
# [*log_dir*]
#  Default: "/var/log/flapjack"
# [*access_log*]
#  Default: "web_access.log"
# [*base_url*]
#  Default: ""
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::jsonapi (
  # Common Config 
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,
  
  # Parameters
  $enabled         = 'yes',
  $port            = 3081,
  $timeout         = 300,
  $log_dir         = '/var/log/flapjack',
  $access_log      = 'jsonapi_access.log',
  $base_url        = "http://localhost:3081/",
  $log_level       = INFO,
  $syslog_errors   = yes,
) {
  # Common Config  
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }
  
  # Web Gateway
  $title_prefix = "flapjack_${name}_gateways_jsonapi"
  $key_prefix = "${environment}/gateways/jsonapi"
  
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
  
  yaml_setting { "${title_prefix}_access_log":
    key    => "${key_prefix}/access_log",
    value  => "${log_dir}/${access_log}",
  }
  
  yaml_setting { "${title_prefix}_base_url":
    key    => "${key_prefix}/base_url",
    value  => $base_url,
  }
  
  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }
  
  if ($refresh_service) {
    Flapjack::Config::Gateway::Jsonapi[$name] ~> Service['flapjack']
  }
}
