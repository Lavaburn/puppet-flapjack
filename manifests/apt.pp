class flapjack::apt {
  apt::source { 'flapjack':
    location    => 'http://packages.flapjack.io/deb/v1',
    repos       => 'main',
    key         => '803709B6',
    include_src => false,
  }
}
