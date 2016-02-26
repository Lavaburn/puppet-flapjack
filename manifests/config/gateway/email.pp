# == Definition: flapjack::config::gateway::email
#
# This definition changes Flapjack configuration:
# - Gateway: Email
#
# === Parameters:
# Common Parameters: See flapjack::config::base
#
# * enabled (boolean): Whether to enable the E-Mail Gateway. Default: true
# * queue (string): Queue name of the alerts that should be sent out using this gateway method. Default: email_notifications
# * smtp_from (string): E-mail address that is sent from. Default: undef
# * smtp_host (string): SMTP Server. Default: 127.0.0.1
# * smtp_port (string): SMTP port. Default: 25
# * smtp_starttls (string): Whether to enable TLS on SMTP. Default: false
# * smtp_domain (string): Domain used for SMTP transport. Default: localhost
# * smtp_auth (string): Whether to authenticate on the SMTP server. Default: false
# * smtp_auth_user (string): Username used when authenticating on the SMTP server. Default: undef
# * smtp_auth_pass (string): Password used when authenticating on the SMTP server. Default: undef
# * templates (hash): Templates used when composing the mail body. Default: undef
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::gateway::email (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled        = true,
  $queue          = 'email_notifications',

  # SMTP
  $smtp_from      = undef,
  $smtp_host      = '127.0.0.1',
  $smtp_port      = 25,
  $smtp_starttls  = false,
  $smtp_domain    = 'localhost',
  $smtp_auth      = false,
  $smtp_auth_user = undef,
  $smtp_auth_pass = undef,

  $templates      = undef,

  # Logging
  $log_level      = 'INFO',
  $syslog_errors  = true,
) {
  # Validation
  validate_absolute_path($config_dir)
  validate_string($config_file, $environment)
  validate_bool($refresh_service, $smtp_auth)
  validate_string($queue, $smtp_host, $smtp_domain)
  validate_bool($enabled, $smtp_starttls)

  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # E-Mail Gateway
  $title_prefix = "flapjack_${name}_gateways_email"
  $key_prefix = "${environment}/gateways/email"

  yaml_setting { "${title_prefix}_enabled":
    key   => "${key_prefix}/enabled",
    value => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key   => "${key_prefix}/queue",
    value => $queue,
  }

  # SMTP Config
  $title_prefix_smtp = "${title_prefix}_smtp_config"
  $key_prefix_smtp = "${key_prefix}/smtp_config"

  if ($smtp_from != undef) {
    validate_string($smtp_from)

    yaml_setting { "${title_prefix_smtp}_from":
      key   => "${key_prefix_smtp}/from",
      value => $smtp_from,
    }
  }

  yaml_setting { "${title_prefix_smtp}_host":
    key   => "${key_prefix_smtp}/host",
    value => $smtp_host,
  }

  yaml_setting { "${title_prefix_smtp}_port":
    key   => "${key_prefix_smtp}/port",
    value => $smtp_port,
  }

  yaml_setting { "${title_prefix_smtp}_starttls":
    key   => "${key_prefix_smtp}/starttls",
    value => $smtp_starttls,
  }

  yaml_setting { "${title_prefix_smtp}_domain":
    key   => "${key_prefix_smtp}/domain",
    value => $smtp_domain,
  }

  if ($smtp_auth) {
    validate_string($smtp_auth_user, $smtp_auth_pass)

    $title_prefix_smtp_auth = "${title_prefix_smtp}_auth"
    $key_prefix_smtp_auth = "${key_prefix_smtp}/auth"

    yaml_setting { "${title_prefix_smtp_auth}_type":
      key   => "${key_prefix_smtp_auth}/type",
      value => $smtp_auth,
    }

    yaml_setting { "${title_prefix_smtp_auth}_username":
      key   => "${key_prefix_smtp_auth}/username",
      value => $smtp_auth_user,
    }

    yaml_setting { "${title_prefix_smtp_auth}_password":
      key   => "${key_prefix_smtp_auth}/password",
      value => $smtp_auth_pass,
    }
  }

  # Templates
    # HASH: eg.
    #   rollup_subject.text: '/etc/flapjack/templates/email/rollup_subject.text.erb'
    #   alert_subject.text: '/etc/flapjack/templates/email/alert_subject.text.erb'
    #   rollup.text: '/etc/flapjack/templates/email/rollup.text.erb'
    #   alert.text: '/etc/flapjack/templates/email/alert.text.erb'
    #   rollup.html: '/etc/flapjack/templates/email/rollup.html.erb'
    #   alert.html: '/etc/flapjack/templates/email/alert.html.erb'
  flapjack::config::template_config { $title_prefix:
    path      => $key_prefix,
    templates => $templates,
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_email_queue":
    key   => "${key_prefix_notifier}/email_queue",
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
    Flapjack::Config::Gateway::Email[$name] ~> Service[$flapjack::service_name]
  }

  # Ordering
  Package[$flapjack::package_name] -> Flapjack::Config::Gateway::Email[$name]
}
