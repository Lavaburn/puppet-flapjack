class flapjack::service {
  service { 'flapjack':
	  ensure     => running,
		enable     => true,
		hasstatus  => true,
		hasrestart => false,
#		require    => [
#		  File['/etc/flapjack/flapjack_config.yaml'],
#	  ],
		subscribe  => [
		  Package['flapjack'],
			#File['/etc/flapjack/flapjack_config.yaml'],
	  ]
  }

	if $flapjack::embedded_redis {
		service { 'redis-flapjack':
		  ensure => running,
			enable => true,
	 }
  }
# Don't even set it up?
#  else {
#	  service { 'redis-flapjack':
#		  ensure     => stopped,
#			enable     => false,
#		}
#	}
}
