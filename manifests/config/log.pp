# == Definition: flapjack::config::log
#
# This is a private definition and should not be used in normal modules.
#
# === Parameters:
# * key_prefix string): The location in the configuration file.
# * log_level (string): The loglevel for this part of the configuration.
# * syslog_errors (boolean): Whether to log errors to syslog.
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::log (
  $key_prefix,
  $log_level,
  $syslog_errors,
) {
  # Validation
  validate_string($key_prefix, $log_level)
  validate_bool($syslog_errors)

  # Logging
  $title_prefix_logger = "${name}_logger"
  $key_prefix_logger = "${key_prefix}/logger"

  yaml_setting { "${title_prefix_logger}_level":
    key   => "${key_prefix_logger}/level",
    value => $log_level,
  }

  yaml_setting { "${title_prefix_logger}_syslog_errors":
    key   => "${key_prefix_logger}/syslog_errors",
    value => $syslog_errors,
  }
}
