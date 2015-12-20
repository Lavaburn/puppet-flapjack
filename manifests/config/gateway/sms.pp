# [*enabled*]
#  Default: no
# [*queue*]
#  Default: sms_notifications
# [*endpoint*]
#  Default: 'https://www.messagenet.com.au/dotnet/Lodge.asmx/LodgeSMSMessage'
# [*username*]
#  Default: username
# [*password*]
#  Default: password
# [*templates*]
#  Default: undef 
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::sms (
  # Common Config 
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',
  
  # Parameters
  $enabled       = 'no',
  $queue         = 'sms_notifications',
  $endpoint      = 'https://www.messagenet.com.au/dotnet/Lodge.asmx/LodgeSMSMessage',
  $username      = 'username',
  $password      = 'password',
  $templates     = undef, 
  $log_level     = INFO,
  $syslog_errors = yes,
) {
  # Common Config  
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }
  
  # SMS (MessageNet) Gateway
  $title_prefix = "flapjack_${name}_gateways_sms"
  $key_prefix = "${environment}/gateways/sms"
  
  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }
  
  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $queue,
  }
  
  yaml_setting { "${title_prefix}_endpoint":
    key    => "${key_prefix}/endpoint",
    value  => $endpoint,
  }
  
  yaml_setting { "${title_prefix}_username":
    key    => "${key_prefix}/username",
    value  => $username,
  }
  
  yaml_setting { "${title_prefix}_password":
    key    => "${key_prefix}/password",
    value  => $password,
  }
      
  # Templates
    # HASH: eg. 
    #  rollup.text: '/etc/flapjack/templates/sms/rollup.text.erb'
    #  alert.text: '/etc/flapjack/templates/sms/alert.text.erb'
  if ($templates != undef) {
	  yaml_setting { "${title_prefix}_templates":
	    key    => "${key_prefix}/templates",
	    value  => $templates,
	  }  
  }
  
  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"
  
  yaml_setting { "${title_prefix_notifier}_sms_queue":
    key    => "${key_prefix_notifier}/sms_queue",
    value  => $queue,
  }
  
  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }
}
