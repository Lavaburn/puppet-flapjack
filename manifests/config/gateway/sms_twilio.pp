# [*enabled*]
#  Default: no
# [*queue*]
#  Default: sms_notifications
# [*account_sid*]
#  Default: 
# [*auth_token*]
#  Default: 
# [*from*]
#  Default: 
# [*templates*]
#  Default: undef 
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::sms_twilio (
  # Common Config 
  $config_dir  = '/etc/flapjack',
  $config_file = 'flapjack_config.yaml',
  $environment = 'production',
  
  # Parameters
  $enabled       = 'no',
  $queue         = 'sms_twilio_notifications',
  $account_sid   = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  $auth_token    = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
  $from          = '+1xxxxxxxxxx',
  $templates     = undef, 
  $log_level     = INFO,
  $syslog_errors = yes,
) {
  # Common Config  
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }
  
  # SMS (Twilio) Gateway
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
  
  yaml_setting { "${title_prefix}_account_sid":
    key    => "${key_prefix}/account_sid",
    value  => $account_sid,
  }
  
  yaml_setting { "${title_prefix}_auth_token":
    key    => "${key_prefix}/auth_token",
    value  => $auth_token,
  }
  
  yaml_setting { "${title_prefix}_from":
    key    => "${key_prefix}/from",
    value  => $from,
  }
      
  # Templates
    # HASH: eg. 
    #   rollup.text: '/etc/flapjack/templates/sms_twilio/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/sms_twilio/alert.text.erb'
  if ($templates != undef) {
	  yaml_setting { "${title_prefix}_templates":
	    key    => "${key_prefix}/templates",
	    value  => $templates,
	  }  
  }
  
  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"
  
  yaml_setting { "${title_prefix_notifier}_sms_twilio_queue":
    key    => "${key_prefix_notifier}/sms_twilio_queue",
    value  => $queue,
  }
  
  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }
}
