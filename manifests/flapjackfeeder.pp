# Class: flapjack::flapjackfeeder
#
# Private class. Only calling flapjack main class is supported.
# Parameters can be overwritten with Hiera (not usually needed)
#
class flapjack::flapjackfeeder (
  $libdir = '/usr/local/lib',
  $user   = 'root',
  $group  = 'root',
) {
  if ($flapjack::install_flapjackfeeder) {
    if ($flapjack::manage_flapjackfeeder_libdir) {
      file { $libdir:
        ensure => 'directory',
        owner  => $user,
        group  => $group,
        mode   => '0755',
      } -> File["${libdir}/flapjackfeeder.o"]
    }

    file { "${libdir}/flapjackfeeder.o":
      source => 'puppet:///modules/flapjack/usr/local/lib/flapjackfeeder.o',
      owner  => $user,
      group  => $group,
      mode   => '0644',
    }
  }
}
