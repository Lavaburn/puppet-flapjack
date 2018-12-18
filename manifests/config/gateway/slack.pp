# == Definition: flapjack::config::gateway::slack
#
# This definition changes Flapjack configuration:
# - Gateway: Slack (Webhook)
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the Slack Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: jabber_notifications
# * format (string): Format to use for notifications. Default: 'text'
# * templates (hash): Templates used when composing the SMS body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::slack (
  # Slack API
  String $format = 'text',

  # Common Config
  String $config_dir       = '/etc/flapjack',
  String $config_file      = 'flapjack_config.yaml',
  String $environment      = 'production',
  Boolean $refresh_service = true,

  # Parameters
  Boolean $enabled = true,
  String $queue    = 'slack_notifications',

  Optional[Hash] $templates = undef,

  # Logging
  String $log_level      = 'INFO',
  Boolean $syslog_errors = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # Slack Gateway
  $title_prefix = "flapjack_${name}_gateways_slack"
  $key_prefix = "${environment}/gateways/slack"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  yaml_setting { "${title_prefix}_format":
    key   => "${key_prefix}/format",
    value => $format,
  }

  # Templates
    # HASH: eg.
    #   rollup.text: '/etc/flapjack/templates/jabber/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/jabber/alert.text.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_slack_queue":
    key   => "${key_prefix_notifier}/slack_queue",
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
    Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Slack[$name] ~> Service[$flapjack::service_name]
  }
}
