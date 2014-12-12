class flapjack::config {
  file { '/var/run/flapjack':
    ensure  => directory,
    mode    => '0755',
    require => [ Package['flapjack'] ],
  }

  file { '/var/log/flapjack':
    ensure  => directory,
    mode    => '0777',
    require => [ Package['flapjack'] ],
  }

  file { '/etc/flapjack':
    ensure  => directory,
    require => [ Package['flapjack'] ],
  }

  file { '/etc/flapjack/flapjack_config.yaml':
    content  => template('flapjack/flapjack_config.yaml.erb'),
  }

  #file { '/etc/init.d/flapjack-web-api':
  #  source  => 'puppet:///modules/flapjack/etc/init.d/flapjack-web-api',
  #}

  file { '/etc/init.d/redis-flapjack':
    mode    => '0744',
    source  => 'puppet:///modules/flapjack/redis-flapjack.init',
  }

  file { '/opt/flapjack/embedded/etc/redis/redis-flapjack.conf':
    source  => 'puppet:///modules/flapjack/redis-flapjack.conf',
  }

  # install and configure logrotate
  if ! defined(Package['logrotate']) {
    ensure_packages['logrotate']
  }

  file { "/etc/logrotate.d/flapjack":
    ensure  => file,
    content => template('flapjack/flapjack_logrotate.conf.erb'),
    require => [
      Package['logrotate'],
      File["/etc/flapjack"],
    ]
  }  

}
