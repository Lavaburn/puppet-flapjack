require 'spec_helper'

describe 'flapjack' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  context "ubuntu" do
  	let(:facts) { {
	  	:osfamily 					      => 'debian',
	  	:operatingsystem 			    => 'Ubuntu',
	  	:lsbdistid					      => 'Ubuntu',
	  	:lsbdistcodename 			    => 'precise',
	  	:operatingsystemrelease 	=> '12.04',
	  	:concat_basedir  			    => '/tmp', # Concat	  	
	  } }
	  
	  context "ubuntu_defaults" do	  
		  it { should compile.with_all_deps }
	  
      it { should contain_class('flapjack') }
      it { should contain_class('flapjack::repo') }
      it { should contain_class('flapjack::install') }
        it { should contain_package('flapjack') }
      it { should contain_class('flapjack::config') }
      it { should contain_class('flapjack::service') }   
        it { should contain_service('flapjack') }     
	    it { should contain_class('flapjack::flapjackfeeder') }
    end
    
    context "ubuntu_package" do          
      let(:params) { {
        :package          => "package.deb",  
        :setup_logrotate  => true,      
      } }
          
      
      it { should compile.with_all_deps }
    
      it { should contain_class('flapjack') }
      it { should_not contain_class('flapjack::repo') }
      it { should contain_class('flapjack::install') }
        it { should contain_package('flapjack') }
      it { should contain_class('flapjack::config') }
        it { should contain_file('/etc/logrotate.d/flapjack') }
      it { should contain_class('flapjack::service') }   
        it { should contain_service('flapjack') }     
      it { should contain_class('flapjack::flapjackfeeder') }
    end
  end
  
  context "centos_defaults" do
  	let(:facts) { {
	    :osfamily 				           => 'redhat',
	  	:operatingsystem 		         => 'CentOS',
#	  	:operatingsystemrelease      => '6.0',
#	  	:lsbmajdistrelease           => '6',
#	  	:operatingsystemmajrelease   => '6',
#	  	:concat_basedir  		         => '/tmp',
#	  	:clientcert				           => 'centos',	# HIERA !!!
	  } }
	  
    let(:params) { {     
      #:enable_tftp           => false,
    } }
    
  	it { should compile.with_all_deps }
  
    it { should contain_class('flapjack') }
    it { should contain_class('flapjack::repo') }
    it { should contain_class('flapjack::install') }
      it { should contain_package('flapjack') }
    it { should contain_class('flapjack::config') }
    it { should contain_class('flapjack::service') }   
      it { should contain_service('flapjack') }     
    it { should contain_class('flapjack::flapjackfeeder') }
  end  
end
