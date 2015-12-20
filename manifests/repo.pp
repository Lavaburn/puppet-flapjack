class flapjack::repo {
  validate_re($flapjack::repo, ['main', 'experimental'])
  validate_re($flapjack::repo_version, ['0.9', 'v1'])

  case $::osfamily {
    'redhat': {
      yumrepo { "flapjack-v1" :
        descr           => "Flapjack, an alert router",
        baseurl         => "http://packages.flapjack.io/rpm/${flapjack::repo_version}/flapjack-${flapjack::repo}/centos/${operatingsystemmajrelease}/${architecture}",
        enabled         => 1,
        gpgcheck        => 0,
        gpgkey          => absent,
        exclude         => absent,
        metadata_expire => absent,
      }
    }
    'debian': {
      include ::apt

      apt::source { 'flapjack':
        location    => "http://packages.flapjack.io/deb/${flapjack::repo_version}",
        repos       => $flapjack::repo,
        key         => '803709B6', # TODO - FULL FINGERPRINT: A9355790877AB44E94580A8E8406B0E3803709B6
        # No longer supported? - include_src => false,
      }
    }
  }
}
