require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
#require 'helpers/exported_resources'
require 'coveralls'

Coveralls.wear!

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
  
#RSpec.configure do |c|
#  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
  
#  c.before do
    # avoid "Only root can execute commands as other users"
#    Puppet.features.stubs(:root? => true)
#  end
#end

# Common code for (most) spec tests
#RSpec.configure do |c|
#  c.before do 
#    
#  end
#end

def ubuntu_facts
  {
    :osfamily                  => 'Debian',
    :operatingsystem           => 'Ubuntu',
    :lsbdistid                 => 'Ubuntu',
    :lsbdistcodename           => 'precise',
    :operatingsystemrelease    => '12.04',
    :operatingsystemmajrelease => '12.04',
    :concat_basedir            => '/tmp',  # Concat
    :puppetversion             => '4.8.1', # Apt
    :virtualenv_version        => '12.0', # Should not matter for spec tests (python dependency)
  }
end

def centos_facts
  {
    :architecture              => 'amd64',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '6.0',
    :operatingsystemmajrelease => '6',
    :lsbmajdistrelease         => '6',
    :concat_basedir            => '/tmp',  # Concat
    :puppetversion             => '4.8.1', # Apt
    :clientcert                => 'centos',  # HIERA !!!
  }
end