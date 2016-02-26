require 'spec_helper'

describe 'flapjack::config::gateway::web', :type => :define do
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
      
      it { should_not contain_yaml_setting("flapjack_customtitle_gateways_web_$logo_image_path") }            
    end     
  end   
end
