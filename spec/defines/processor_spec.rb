require 'spec_helper'

describe 'flapjack::config::processor', :type => :define do
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

      it { should contain_flapjack__config__log("flapjack_customtitle_processor") }
    end
  end   
end
