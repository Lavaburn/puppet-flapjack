# Puppet Module for Flapjack
===================================

[![Build Status](https://travis-ci.org/Lavaburn/puppet-flapjack.png)](https://travis-ci.org/Lavaburn/puppet-flapjack)
[![Coverage Status](https://coveralls.io/repos/github/Lavaburn/puppet-flapjack/badge.svg)](https://coveralls.io/github/Lavaburn/puppet-flapjack)
[![Puppet Forge](http://img.shields.io/puppetforge/v/Lavaburn/flapjack.svg)](https://forge.puppetlabs.com/Lavaburn/flapjack)

## Overview
This module installs and configures Flapjack.
It also contains several defined types for configuring through the REST API.

## Dependencies
* puppetlabs/stdlib
* reidmv/yamlfile

Optional:
* yo61/logrotate

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
  package_source => '/tmp/mypackage.deb'
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
  host     => '127.0.0.1',
  port     => 6379,			# Default = 6380 (embedded redis)
  password => 'stronghash'	# Default = false (NOAUTH)
}
```

Enable the processor
```
flapjack::config::processor { 'production':
  new_check_scheduled_maintenance_duration => '1 day', # Highly recommended to change
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
  port    => 3080,						# Default
  api_url => "http://myhostname:3081/",	# Should be reachable from browser !!
}
```

Enable the JSON API 'gateway'
```
flapjack::config::gateway::jsonapi { 'production':
  port 	   => 3081,							# Default
  base_url => "http://myhostname:3081/",	# Should be valid
}
```

Enable the E-mail Gateway
```
flapjack::config::gateway::email { 'production':
  smtp_from   => 'test@example.com',
  smtp_host   => 'smtp.mydomain.com',
  smtp_domain => 'mydomain.com',
}
```

Other gateways include:
* SMS (Messagenet)
* SMS_Twilio
* Pagerduty
* (Amazon) SNS
* Jabber
* OOBETET

## Supported Environments

* Ruby 1.9.3 - TODO
* Ruby 2.1.8 - TODO
* Ruby 2.2.4 - TODO

* Puppet 3.7.5 - TODO
* Puppet 3.8.5 - TODO
* Puppet 4.2.3 - TODO
* Puppet 4.3.1 - TODO

Acceptance tested on:
* Ubuntu 14.04

## Testing

### Set up for testing
```
gem install bundler
bundle install
```

To choose a different Puppet version, use PUPPET_VERSION environmental variable
```
PUPPET_VERSION="4.2.3" bundle install
```

### Syntax and Spec Testing
```
bundle exec rake test
```

### Acceptance testing with Beaker
```
bundle exec rake beaker
```
You can use the environmental variables BEAKER_debug, BEAKER_destroy and BEAKER_provision 