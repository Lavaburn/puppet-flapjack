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
  	let(:facts) { {
	  	:osfamily 					      => 'Debian',
	  	:operatingsystem 			    => 'Ubuntu',
	  	:lsbdistid					      => 'Ubuntu',
	  	:lsbdistcodename 			    => 'precise',
	  	:operatingsystemrelease 	=> '12.04',
	  	:concat_basedir  			    => '/tmp', # Concat	 
      :puppetversion            => '3.8.5',
      :virtualenv_version       => '12.0', # Should not matter for spec tests (python dependency)
	  } }
	  	  
	  context "ubuntu_defaults" do	  	    
		  it { should compile.with_all_deps }
	  
      it { should contain_class('flapjack::api') }
        
      it { should contain_file('/etc/flapjack') }
      it { should contain_file('/etc/flapjack/puppet_api.yaml') }
        
      it { should contain_package('rest-client') }
    end
  end
end
