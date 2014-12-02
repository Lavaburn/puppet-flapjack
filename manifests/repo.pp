class flapjack::repo {


case $::osfamily {
   'redhat': {
     yumrepo { "flapjack-v1" :
       descr => "Flapjack, an alert router",
       baseurl => "http://packages.flapjack.io/rpm/v1/flapjack/centos/${operatingsystemmajrelease}/${arch}",
       enabled => 1,
       gpgcheck => 0,
       gpgkey => absent,
       exclude => absent,
       metadata_expire => absent,
     }
   }
   'debian': {
     apt::source { 'flapjack':
       location    => 'http://packages.flapjack.io/deb/v1',
       repos       => 'main',
       key         => '803709B6',
       include_src => false,
     }
   }
}


}
