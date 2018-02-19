require 'spec_helper'

describe 'flapjack::config::gateway::web', :type => :define do
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
      
      it { should_not contain_yaml_setting("flapjack_customtitle_gateways_web_$logo_image_path") }            
    end     
  end   
end
