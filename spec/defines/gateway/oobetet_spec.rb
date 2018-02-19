require 'spec_helper'

describe 'flapjack::config::gateway::oobetet', :type => :define do
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
  end   
end
