require 'spec_helper'

describe 'flapjack::config::base', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let(:pre_condition) {[
    "class { 'flapjack': }"
  ]}
    
  context "ubuntu" do
  	let(:facts) { {
	  	:osfamily 					      => 'Debian',
	  	:operatingsystem 			    => 'Ubuntu',
	  	:lsbdistid					      => 'Ubuntu',
	  	:lsbdistcodename 			    => 'precise',
	  	:operatingsystemrelease 	=> '12.04',
	  	:concat_basedir  			    => '/tmp', # Concat	 
	  } }
    
    context "default" do
      let(:title) {
        'customtitle'
      }
      
      it { should contain_file("/etc/flapjack") }
      it { should contain_file("/etc/flapjack/flapjack_config.yaml") }        
      it { should contain_file("/var/run/flapjack/") }
      it { should contain_file("/var/log/flapjack/") }
        
      it { should contain_flapjack__config__log("flapjack_customtitle_base") }
    end
  end   
end
