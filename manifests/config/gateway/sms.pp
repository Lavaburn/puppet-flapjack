# == Definition: flapjack::config::gateway::sms
#
# This definition changes Flapjack configuration:
# - Gateway: MessageNet SMS
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Twilio SMS Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: sms_notifications
# * endpoint (string): MessageNet AUS API Endpoint
# * username (string): MessageNet AUS API Username
# * password (string):  MessageNet AUS API Password
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::sms (
  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'sms_notifications',

  # MessageNet AUS
  String $endpoint = 'https://www.messagenet.com.au/dotnet/Lodge.asmx/LodgeSMSMessage',
  String $username = 'username',
  String $password = 'password',

  Optional[Hash] $templates = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # SMS (MessageNet) Gateway
  $title_prefix = "flapjack_${name}_gateways_sms"
  $key_prefix = "${environment}/gateways/sms"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  yaml_setting { "${title_prefix}_endpoint":
    key   => "${key_prefix}/endpoint",
    value => $endpoint,
  }

  yaml_setting { "${title_prefix}_username":
    key   => "${key_prefix}/username",
    value => $username,
  }

  yaml_setting { "${title_prefix}_password":
    key   => "${key_prefix}/password",
    value => $password,
  }

  # Templates
    # HASH: eg.
    #  rollup.text: '/etc/flapjack/templates/sms/rollup.text.erb'
    #  alert.text: '/etc/flapjack/templates/sms/alert.text.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_sms_queue":
    key   => "${key_prefix_notifier}/sms_queue",
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
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Sms[$name] ~> Service[$flapjack::service_name]
  }
}
