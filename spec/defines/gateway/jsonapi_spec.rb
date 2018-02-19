require 'spec_helper'

describe 'flapjack::config::gateway::jsonapi', :type => :define do
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
      
      #it { should contain_yaml_setting("flapjack_customtitle_gateways_email_templates_b").with_value('2B') }            
    end 
  end   
end
