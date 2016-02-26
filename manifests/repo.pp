# Class: flapjack::repo
#
# Private class. Only calling flapjack main class is supported.
#
class flapjack::repo {
  case $::osfamily {
    'RedHat': {
      yumrepo { 'flapjack' :
        descr           => 'Flapjack, an alert router',
        baseurl         => "http://packages.flapjack.io/rpm/${flapjack::repo_version}/flapjack-${flapjack::repo_name}/centos/${::operatingsystemmajrelease}/${::architecture}",
        enabled         => 1,
        gpgcheck        => 0,
        gpgkey          => absent,
        exclude         => absent,
        metadata_expire => absent,
      }
    }
    'Debian': {
      include ::apt

      apt::source { 'flapjack':
        location => "http://packages.flapjack.io/deb/${flapjack::repo_version}",
        repos    => $flapjack::repo_name,
        key      => 'A9355790877AB44E94580A8E8406B0E3803709B6',
      }
    }
    default: {
      fail("Operating System ${::osfamily} is not supported currently.")
    }
  }
}
