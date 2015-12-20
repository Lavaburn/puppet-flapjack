# [*redis_host*]
#   redis host. Default: 127.0.0.1
# [*redis_port*]
#   redis port. Default: 6380
# [*redis_db*]
#   redis database. Default: 0
define flapjack::config::redis (
  # Common Config 
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',
  $refresh_service = true,
  
  # Parameters
  $host = '127.0.0.1',
  $port = 6380,
  $db   = 0,
) {
  # Common Config 
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }
  
  # Redis
  $title_prefix = "flapjack_${environment}_redis"
  $key_prefix = "${environment}/redis"
  
  yaml_setting { "${title_prefix}_host":
    key    => "${key_prefix}/host",
    value  => $host,
  }
  
  yaml_setting { "${title_prefix}_port":
    key    => "${key_prefix}/port",
    value  => $port,
  }
  
  yaml_setting { "${title_prefix}_db":
    key    => "${key_prefix}/db",
    value  => $db,
  }
  
  if ($refresh_service) {
    Flapjack::Config::Redis[$name] ~> Service['flapjack']
  }
}