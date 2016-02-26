require 'spec_helper'

describe 'flapjack::config::gateway::email', :type => :define do
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
      
      it { should_not contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_from") }
      it { should_not contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_auth_type") }
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
          'c' => '1C',
        },
      } }
      
      it { should contain_flapjack__config__template_config('flapjack_customtitle_gateways_email') }
        
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_templates_a").with_key('testing/gateways/email/templates/a') }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_templates_b").with_value('2B') }              
    end
    
    context "authenticated" do
      let(:title) {
        'customtitle'
      }
      
      let(:params) { {
        :smtp_from      => 'test@example.com',
        :smtp_auth      => true,
        :smtp_auth_user => 'U',
        :smtp_auth_pass => 'P',
      } }
      
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_from").with_value('test@example.com') }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_auth_type").with_value(true) }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_auth_username").with_value('U') }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_email_smtp_config_auth_password").with_value('P') }
    end  
  end   
end
