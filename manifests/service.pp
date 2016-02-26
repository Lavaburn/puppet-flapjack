# Class: flapjack::service
#
# Private class. Only calling flapjack main class is supported.
#
class flapjack::service {
  # Flapjack Service
  Package[$flapjack::package_name]
  ~>
  service { $flapjack::service_name:
    ensure => $flapjack::service_ensure,
  }

  # Embedded Redis Service
  if $flapjack::embedded_redis {
    service { $flapjack::embedded_redis_service_name:
      ensure => $flapjack::embedded_redis_service_ensure,
    }
  }
}
