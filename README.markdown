puppet-flapjack
===============

##Overview

This module installs and configures flapjack.


##Setup

```puppet
class { 'flapjack':
  redis_host     => '127.0.0.1',
  embedded_redis => false,
}
```

