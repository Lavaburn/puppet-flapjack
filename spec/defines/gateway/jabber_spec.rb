require 'spec_helper'

describe 'flapjack::config::gateway::jabber', :type => :define do
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
    end
    
    context "with custom templates" do              
      let(:title) {
        'customtitle'
      }
      
      let(:params) { {
        :environment => 'testing',
        :templates   => {
          'a' => '1A',
          'b' => '2B',
        },
      } }
      
      it { should contain_flapjack__config__template_config('flapjack_customtitle_gateways_jabber') }
        
      it { should contain_yaml_setting("flapjack_customtitle_gateways_jabber_templates_a").with_key('testing/gateways/jabber/templates/a') }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_jabber_templates_b").with_value('2B') }              
    end	  
  end   
end
