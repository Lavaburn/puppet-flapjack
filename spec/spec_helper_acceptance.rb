require 'beaker-rspec'
require 'pry'

hosts.each do |host|
  # Using box with pre-installed Puppet !
    
  # ON PROVISION ONLY !		on host, "apt-get update"
end

RSpec.configure do |c|
	# Project root
    proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

	# Readable test descriptions
  	c.formatter = :documentation

	# Configure all nodes in nodeset
  	c.before :suite do
  		# Install dependencies
  		 hosts.each do |host|
         on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
	       on host, puppet('module', 'install', 'reidmv-yamlfile'), { :acceptable_exit_codes => [0,1] }
	     end
  	
		# Install module
		puppet_module_install(:source => proj_root, :module_name => 'flapjack')
  end
end



