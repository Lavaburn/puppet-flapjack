# Class: flapjack::install
#
# Private class. Only calling flapjack main class is supported.
#
class flapjack::install {
  if ($flapjack::package_source == undef) {
    # Install from Repository
    include flapjack::repo

    package { $flapjack::package_name:
      ensure => $flapjack::package_version
    }

    Class['flapjack::repo'] -> Package['flapjack']
  } else {
    case $::osfamily {
      'RedHat': {
        # RPM is not versionable ???
        package { $flapjack::package_name:
          ensure   => 'latest',
          source   => $flapjack::package_source,
          provider => 'rpm',
        }
      }
      'Debian': {
        # DPKG is not versionable
        package { $flapjack::package_name:
          ensure   => 'latest',
          source   => $flapjack::package_source,
          provider => 'dpkg',
        }
      }
      default: {
        fail("Operating System ${::osfamily} is not supported currently.")
      }
    }
  }
}
