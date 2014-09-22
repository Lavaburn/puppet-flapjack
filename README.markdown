puppet-flapjack
===============

##Overview

This module installs and configures flapjack.


##Setup

```puppet
class { 'flapjack':
  redis_host     => $haproxy_vip,
  embedded_redis => false,
}
```

