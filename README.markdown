puppet-flapjack
===============

## Overview

This module installs and configures flapjack.


## Dependencies

* puppetlabs/stdlib
* reidmv/yamlfile

Optional:
* puppetlabs/apt ?
* yumrepo ?

## Installation

1. Default settings
```
class { 'flapjack': }
```

2. With logrotate enabled (requires logrotate to be installed first!)
```
class { 'flapjack':
  setup_logrotate => true,
}
```

3. Custom package (self-built)
```
class { 'flapjack':
  package => '/tmp/mypackage.deb'
}
```

## Configuration

1. Production environment in /etc/flapjack/flapjack_config.yaml
```
flapjack::config::base { 'production': }
```

2. Development environment in /etc/flapjack/flapjack_config1.yaml
```
flapjack::config::base { 'dev':
  config_file     => 'flapjack_config1.yaml',
  environment     => 'dev',
}
```

3. Change the log level
```
flapjack::config::base { 'production': 
  log_level => DEBUG,
}
```
The above parameters need to be applied to every section below. 

Redis Config
```
flapjack::config::redis { 'production':
  host => '127.0.0.1',
  port => 6380,
  db   => 0,
}
```

Enable the processor
```
flapjack::config::processor { 'production':
  new_check_scheduled_maintenance_duration => '1 day',
}
```

Enable the notifier
```
flapjack::config::notifier { 'production': }
```

Enable Nagios processing
```
flapjack::config::nagios { 'production': }
```

Enable the WEB 'gateway'
```
flapjack::config::gateway::web { 'production':
  # enabled => 'yes', => Should be automatic by including it?
  port      => 3080,
  api_url   => "http://myhostname:3081/",
}
```

Enable the JSON API 'gateway'
```
flapjack::config::gateway::jsonapi { 'production':
  # enabled => 'yes', => Should be automatic by including it?
  port      => 3081,
}
```

Enable the E-mail Gateway
```
flapjack::config::gateway::email { 'production':
  # enabled => 'yes', => Should be automatic by including it?
  smtp_host      => 'smtp.mydomain.com',
  smtp_domain    => 'mydomain.com',
}
```

Other gateways include:
* SMS (Messagenet)
* SMS_Twilio
* Pagerduty
* (Amazon) SNS
* Jabber
* OOBETET
