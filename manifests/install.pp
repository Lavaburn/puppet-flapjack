class flapjack::install {
  if ($flapjack::package == undef) {
    # Install from Repository
    package { 'flapjack':
      ensure => $flapjack::version
    }
  } else {
    package { 'flapjack':
      ensure   => $flapjack::version,
      source   => $flapjack::package,
      provider => 'dpkg',
    }
  }
}
