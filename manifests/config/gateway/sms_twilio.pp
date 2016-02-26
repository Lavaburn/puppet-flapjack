# == Definition: flapjack::config::gateway::sms_twilio
#
# This definition changes Flapjack configuration:
# - Gateway: Twilio SMS
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Twilio SMS Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: sms_twilio_notifications
# * account_sid (string): Twilio API Account ID
# * auth_token (string): Twilio API Account Token
# * from (string):  Telephone number from which to send
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::sms_twilio (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled       = true,
  $queue         = 'sms_twilio_notifications',

  # Twilio API
  $account_sid   = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  $auth_token    = 'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy',
  $from          = '+1xxxxxxxxxx',

  $templates     = undef,

  # Logging
  $log_level     = 'INFO',
  $syslog_errors = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service)
  validate_string($queue, $account_sid, $auth_token, $from, $log_level)
  validate_bool($enabled, $syslog_errors)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # SMS (Twilio) Gateway
  $title_prefix = "flapjack_${name}_gateways_sms_twilio"
  $key_prefix = "${environment}/gateways/sms_twilio"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  yaml_setting { "${title_prefix}_account_sid":
    key   => "${key_prefix}/account_sid",
    value => $account_sid,
  }

  yaml_setting { "${title_prefix}_auth_token":
    key   => "${key_prefix}/auth_token",
    value => $auth_token,
  }

  yaml_setting { "${title_prefix}_from":
    key   => "${key_prefix}/from",
    value => $from,
  }

  # Templates
    # HASH: eg.
    #   rollup.text: '/etc/flapjack/templates/sms_twilio/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/sms_twilio/alert.text.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_sms_twilio_queue":
    key   => "${key_prefix_notifier}/sms_twilio_queue",
    value => $queue,
  }

  # Logging
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  # Restart Service
  if ($refresh_service) {
    Flapjack::Config::Gateway::Sms_twilio[$name] ~> Service[$flapjack::service_name]
  }

  # Ordering
  Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Sms_twilio[$name]
}
