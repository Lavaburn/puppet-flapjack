require 'spec_helper'

describe 'flapjack::api' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)

  let(:pre_condition) {[
    <<-EOS
      class { '::flapjack': }
    EOS
  ]}
  
  context "ubuntu" do
  	let(:facts) { ubuntu_facts }
	  	  
	  context "ubuntu_defaults" do	  	    
		  it { should compile.with_all_deps }
	  
      it { should contain_class('flapjack::api') }
        
      it { should contain_file('/etc/flapjack/puppet_api.yaml') }
        
      it { should contain_package('rest-client') }
    end
  end
end
