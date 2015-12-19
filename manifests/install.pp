class flapjack::install {
  if ($flapjack::package == undef) {
    # Install from Repository
    package { 'flapjack': 
      ensure => present
    } 
  } else {     
    package { 'flapjack': 
      provider => dpkg,
      ensure   => installed,
      source   => $flapjack::package,
    }
  }
}
