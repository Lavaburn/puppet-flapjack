# Class: flapjack::api
#
# This class manages the configuration file that Puppet uses to call the Flapjack REST API.
#
# Parameters:
# * host (string): The host to call the API on. Default: 127.0.0.1
# * port (integer): The port to call the API on. Default: 3081
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
class flapjack::api (
  $host  = '127.0.0.1',
  $port  = 3081,
) {
  validate_string($host)

  # Config file location is currently statically configured (flapjack_rest.rb)
  $flapjack_config_dir = '/etc/flapjack'
  $api_auth_file = "${flapjack_config_dir}/puppet_api.yaml"

  # How can I reach the REST API?
  $api_host = $host
  $api_port = $port

  file { $api_auth_file:
    ensure  => file,
    content => template('flapjack/api.yaml.erb')
  }

  # Dependency Gems Installation
  if versioncmp($::puppetversion, '4.0.0') < 0 {
    ensure_packages(['rest-client'], {'ensure' => 'present', 'provider' => 'gem'})
  } else {
    ensure_packages(['rest-client'], {'ensure' => 'present', 'provider' => 'puppet_gem'})
  }
}
