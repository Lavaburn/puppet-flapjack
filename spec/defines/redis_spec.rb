require 'spec_helper'

describe 'flapjack::config::redis', :type => :define do
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
        
      it { should contain_yaml_setting("flapjack_customtitle_redis_password").with_ensure('absent') }
    end
    
    context "default" do
      let(:title) {
        'customtitle'
      }
      
      let(:params) { {
        'password' => 'PW'
      } }
      
      it { should contain_yaml_setting("flapjack_customtitle_redis_password").with_value('PW') }
    end
  end   
end
