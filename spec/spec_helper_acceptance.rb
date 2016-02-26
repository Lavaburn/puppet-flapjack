require 'beaker-rspec'
#require 'pry'

# Puppet Installation 
#hosts.each do |host|
#  # Using box with pre-installed Puppet !
#  # run_puppet_install_helper => require 'beaker/puppet_install_helper'
#end

# Install Dependencies
unless ENV['BEAKER_provision'] == 'no'
  hosts.each do |host|
    if fact('osfamily') == 'Debian'
      on host, "apt-get update"
        
      # Dependencies for gem install 'rest-client'
      on host, "apt-get install -y g++"
    end
    
    on host, puppet('module', 'install', 'puppetlabs-apt'), { :acceptable_exit_codes => [0,1] }
    on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
    on host, puppet('module', 'install', 'reidmv-yamlfile'), { :acceptable_exit_codes => [0,1] }
  end
end

# Setup Test Suite
RSpec.configure do |c|
	# Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

	# Readable test descriptions
  c.formatter = :documentation

  # Install module
  c.before :suite do
    puppet_module_install(:source => proj_root, :module_name => 'flapjack')
  end
end
