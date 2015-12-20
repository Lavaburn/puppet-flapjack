define flapjack::config::log (
  $key_prefix,
  $log_level,
  $syslog_errors,
) {
  $title_prefix_logger = "${name}_logger"
  $key_prefix_logger = "${key_prefix}/logger"
   
  yaml_setting { "${title_prefix_logger}_level":
    key    => "${key_prefix_logger}/level",
    value  => $log_level,
  }
  
  yaml_setting { "${title_prefix_logger}_syslog_errors":
    key    => "${key_prefix_logger}/syslog_errors",
    value  => $syslog_errors,
  }
}
