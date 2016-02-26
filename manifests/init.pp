# Class: flapjack
#
# This module manages Flapjack
#
# Parameters:
# * repo_version (string): Repository version (0.9/v1/v2). Default: v1
# * repo_name (string): Repository (main/experimental). Default: main
# * package_name (string): Name of the package to install. Default: flapjack
# * package_version (string): Version of the package to install. Default: installed
# * package_source (string): Package file for custom DEB/RPM installation
# * setup_logrotate (boolean): Whether to set up logrotate. Default: false
# * log_dir (path): Path to the log directory. Default: /var/log/flapjack
# * rotate_count (integer): Frequency of logrotation. Allowed: hour/day/week/month/year. Default: 'week'
# * rotate_every (string): Archive count of logrotation. Default: 12
# * embedded_redis (boolean): Whether to use embedded Redis. Default: false
# * install_flapjackfeeder (boolean): Whether to install flapjackfeeder.o. Default: false
# * manage_flapjackfeeder_lib (boolean): Whether to manage library directory for flapjackfeeder.o. Default: false
#
# === Dependencies/Requirements
# see README
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class flapjack (
  # Repository
  $repo_version = 'v1',
  $repo_name    = 'main',

  # Package
  $package_name    = 'flapjack',
  $package_version = 'installed',
  $package_source  = undef,

  # Configuration
  $setup_logrotate = false,
  $log_dir         = '/var/log/flapjack',
  $rotate_count    = 12,
  $rotate_every    = 'week',
  $embedded_redis  = false,

  # Flapjackfeeder
  $install_flapjackfeeder       = false,
  $manage_flapjackfeeder_libdir = false,

  # Service
  $service_name                   = 'flapjack',
  $service_ensure                 = 'running',
  $embedded_redis_service_name    = 'redis-flapjack',
  $embedded_redis_service_ensure  = 'running',
) {
  # Validation
  validate_re($repo_version, ['0.9', 'v1', 'v2'])
  validate_re($repo_name, ['main', 'experimental'])
  validate_string($package_name, $package_version)
  validate_bool($setup_logrotate, $embedded_redis)
  validate_absolute_path($log_dir)
  validate_re($rotate_every, ['hour', 'day', 'week', 'month', 'year'])
  validate_bool($install_flapjackfeeder, $manage_flapjackfeeder_libdir)

  # Sub-classes
  include flapjack::install
  include flapjack::config
  include flapjack::flapjackfeeder
  include flapjack::service

  # Dependency Chain
  Class['::flapjack']
  ->
  Class['flapjack::install']
  ->
  Class['flapjack::config']
  ->
  Class['flapjack::flapjackfeeder']
  ~>
  Class['flapjack::service']
}
