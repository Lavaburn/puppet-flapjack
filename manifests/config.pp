# Class: flapjack::config
#
# Private class. Only calling flapjack main class is supported.
#
class flapjack::config {
  # Logrotate
  if ($flapjack::setup_logrotate) {
    Package[$flapjack::package_name]
    ->
    logrotate::rule { 'flapjack':
      path         => "${flapjack::log_dir}/*.log",
      rotate       => $flapjack::rotate_count,
      rotate_every => $flapjack::rotate_every,
      copytruncate => true,
      missingok    => true,
      ifempty      => false,
      compress     => true,
    }
  }

  # Embedded Redis
  if ($flapjack::embedded_redis) {
    case $::osfamily {
      'RedHat': {
        file { '/etc/init.d/redis-flapjack':
          mode   => '0744',
          source => 'puppet:///modules/flapjack/redis-flapjack.init',
        }
        file { '/opt/flapjack/embedded/etc/redis/redis-flapjack.conf':
          source  => 'puppet:///modules/flapjack/redis-flapjack.conf',
        }
      }
      default: {
        fail("Embedded Redis is currently not supported on Operating System ${::osfamily}.")
      }
    }
  }
}
