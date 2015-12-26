# [*enabled*]
#  Default: no
# [*queue*]
#  Default: email_notifications
# [*smtp_from*]
#  Default: undef
# [*smtp_host*]
#  Default: 127.0.0.1
# [*smtp_port*]
#  Default: 25
# [*smtp_starttls*]
#  Default: false
# [*smtp_domain*]
#  Default: localhost
# [*smtp_auth*]
#  Default: false
# [*smtp_auth_user*]
#  Default: undef
# [*smtp_auth_pass*]
#  Default: undef
# [*templates*]
#  Default: undef
# [*log_level*]
#  Default: INFO
# [*syslog_errors*]
#  Default: yes
define flapjack::config::gateway::email (
  # Common Config
  $config_dir      = '/etc/flapjack',
  $config_file     = 'flapjack_config.yaml',
  $environment     = 'production',
  $refresh_service = true,

  # Parameters
  $enabled        = true,
  $queue          = 'email_notifications',
  $smtp_from      = undef,
  $smtp_host      = '127.0.0.1',
  $smtp_port      = 25,
  $smtp_starttls  = false,
  $smtp_domain    = 'localhost',
  $smtp_auth      = false,
  $smtp_auth_user = undef,
  $smtp_auth_pass = undef,
  $templates      = undef,
  $log_level      = 'INFO',
  $syslog_errors  = true,
) {
  # Common Config
  Yaml_setting {
    target => "${config_dir}/${config_file}",
  }

  # E-Mail Gateway
  $title_prefix = "flapjack_${name}_gateways_email"
  $key_prefix = "${environment}/gateways/email"

  yaml_setting { "${title_prefix}_enabled":
    key    => "${key_prefix}/enabled",
    value  => $enabled,
  }

  yaml_setting { "${title_prefix}_queue":
    key    => "${key_prefix}/queue",
    value  => $queue,
  }

  # SMTP Config
  $title_prefix_smtp = "${title_prefix}_smtp_config"
  $key_prefix_smtp = "${key_prefix}/smtp_config"

  if ($smtp_from != undef) {
    yaml_setting { "${title_prefix_smtp}_from":
      key    => "${key_prefix_smtp}/from",
      value  => $smtp_from,
    }
  }

  yaml_setting { "${title_prefix_smtp}_host":
    key    => "${key_prefix_smtp}/host",
    value  => $smtp_host,
  }

  yaml_setting { "${title_prefix_smtp}_port":
    key    => "${key_prefix_smtp}/port",
    value  => $smtp_port,
  }

  yaml_setting { "${title_prefix_smtp}_starttls":
    key    => "${key_prefix_smtp}/starttls",
    value  => $smtp_starttls,
  }

  yaml_setting { "${title_prefix_smtp}_domain":
    key    => "${key_prefix_smtp}/domain",
    value  => $smtp_domain,
  }

  if ($smtp_auth) {
    $title_prefix_smtp_auth = "${title_prefix_smtp}_auth"
    $key_prefix_smtp_auth = "${key_prefix_smtp}/auth"

    yaml_setting { "${title_prefix_smtp_auth}_type":
      key    => "${key_prefix_smtp_auth}/type",
      value  => $smtp_auth,
    }

    yaml_setting { "${title_prefix_smtp_auth}_username":
      key    => "${key_prefix_smtp_auth}/username",
      value  => $smtp_auth_user,
    }

    yaml_setting { "${title_prefix_smtp_auth}_password":
      key    => "${key_prefix_smtp_auth}/password",
      value  => $smtp_auth_pass,
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
  if ($templates != undef) {
	  yaml_setting { "${title_prefix}_templates":
	    key    => "${key_prefix}/templates",
	    value  => $templates,
	  }
  }

  # Notifier
  $title_prefix_notifier = "flapjack_${environment}_notifier"
  $key_prefix_notifier = "${environment}/notifier"

  yaml_setting { "${title_prefix_notifier}_email_queue":
    key    => "${key_prefix_notifier}/email_queue",
    value  => $queue,
  }

  # Log
  flapjack::config::log { $title_prefix:
    key_prefix    => $key_prefix,
    log_level     => $log_level,
    syslog_errors => $syslog_errors,
  }

  if ($refresh_service) {
    Flapjack::Config::Gateway::Email[$name] ~> Service['flapjack']
  }
}
