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
class flapjack (
  # Repository/Package
  $package        = undef,
  $repo_version   = 'v1',
  $repo           = 'main',
  $embedded_redis = true,
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
