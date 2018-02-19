require 'spec_helper'

describe 'flapjack::config::gateway::hipchat', :type => :define do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  let(:pre_condition) {[
    "class { 'flapjack': }"
  ]}
    
  context "ubuntu" do
  	let(:facts) { ubuntu_facts }
	  
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
        :auth_token  => 'TOKEN123',
        :environment => 'testing',
        :templates   => {
          'a' => '1A',
          'b' => '2B',
        },
      } }
      
      it { should contain_flapjack__config__template_config('flapjack_customtitle_gateways_hipchat') }
        
      it { should contain_yaml_setting("flapjack_customtitle_gateways_hipchat_templates_a").with_key('testing/gateways/hipchat/templates/a') }
      it { should contain_yaml_setting("flapjack_customtitle_gateways_hipchat_templates_b").with_value('2B') }              
    end	  
  end   
end
