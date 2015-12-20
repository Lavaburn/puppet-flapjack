# === Parameters
#
# [*package*]
#   package file for custom DEB installation (RPM not currently supported)
# [*repo_version*]
#   APT repository version
# [*repo*]
#   APT repository 
# [*embedded_redis*]
#   use embedded redis. Default: true
# [*setup_logrotate*]
#   Setup the logrotate config
class flapjack (
  # Repository/Package
  $package         = undef,
  $repo_version    = 'v1',
  $repo            = 'main',
  $embedded_redis  = true,
  $setup_logrotate = false,
) {
  if ($package == undef) {
	  class { 'flapjack::repo':
	
    } -> Class['flapjack::install']
  }
  
  class { 'flapjack::install':

  } ->
  class { 'flapjack::config':

  } ~>
  class { 'flapjack::service':

  } ->
  class { 'flapjack::flapjackfeeder':

  } -> Class['flapjack']
}
