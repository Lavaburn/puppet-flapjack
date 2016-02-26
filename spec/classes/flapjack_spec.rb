require 'spec_helper'

describe 'flapjack' do
  Puppet::Util::Log.level = :warning
  Puppet::Util::Log.newdestination(:console)
  
  context "ubuntu" do
  	let(:facts) { {
	  	:osfamily 					    => 'Debian',
	  	:operatingsystem 			  => 'Ubuntu',
	  	:lsbdistid					    => 'Ubuntu',
	  	:lsbdistcodename 			  => 'precise',
	  	:operatingsystemrelease => '12.04',
	  } }
	  
	  context "ubuntu_defaults" do	  
		  it { should compile.with_all_deps }
	  
      it { should contain_class('flapjack') }
      it { should contain_class('flapjack::install') }
        it { should contain_class('flapjack::repo') }
          it { should contain_apt__source('flapjack') }
        it { should contain_package('flapjack') }
      it { should contain_class('flapjack::config') } 
      it { should contain_class('flapjack::service') }   
        it { should contain_service('flapjack') }   
    end
    
    context "ubuntu_package" do          
      let(:params) { {
        :package_source => "package.deb",  
      } }
         
      it { should compile.with_all_deps }
        
      it { should_not contain_class('flapjack::repo') }

      it { should contain_package('flapjack').with(
        'provider' => 'dpkg'
      ) }
    end
    
    context "ubuntu_logrotate" do          
      let(:params) { {
        :setup_logrotate => true
      } }
         
      it { should compile.with_all_deps }

      it { should contain_logrotate__rule('flapjack') }      
    end
    
    context "ubuntu_flapjackfeeder" do          
      let(:params) { {
        :install_flapjackfeeder       => true,
        :manage_flapjackfeeder_libdir => true
      } }
         
      it { should compile.with_all_deps }
          
      it { should contain_file('/usr/local/lib') }
      it { should contain_file('/usr/local/lib/flapjackfeeder.o') }
    end
  end
  
  context "centos" do
  	let(:facts) { {
	    :osfamily 				      => 'RedHat',
	  	:operatingsystem 		    => 'CentOS',
	  	:operatingsystemrelease => '6.0',
	  	:lsbmajdistrelease      => '6',
	  	:clientcert				      => 'centos',	# HIERA !!!
	  } }
	  
    context "centos_defaults" do
      it { should compile.with_all_deps }
    
      it { should contain_class('flapjack') }
      it { should contain_class('flapjack::install') }
        it { should contain_class('flapjack::repo') }
          it { should contain_yumrepo('flapjack') }
        it { should contain_package('flapjack') }
      it { should contain_class('flapjack::config') } 
      it { should contain_class('flapjack::service') }   
        it { should contain_service('flapjack') }   
    end
    
    context "centos_package" do          
      let(:params) { {
        :package_source => "package.rpm",  
      } }
         
      it { should compile.with_all_deps }
        
      it { should_not contain_class('flapjack::repo') }

      it { should contain_package('flapjack').with(
        'provider' => 'rpm'
      ) }
    end
    
    context "centos_logrotate" do          
      let(:params) { {
        :setup_logrotate => true
      } }
         
      it { should compile.with_all_deps }

      it { should contain_logrotate__rule('flapjack') }      
    end
    
    context "centos_embedded_redis" do          
      let(:params) { {
        :embedded_redis => true,
      } }
         
      it { should compile.with_all_deps }

      it { should contain_file('/etc/init.d/redis-flapjack') }
      it { should contain_file('/opt/flapjack/embedded/etc/redis/redis-flapjack.conf') }
    end
    
    context "centos_flapjackfeeder" do          
      let(:params) { {
        :install_flapjackfeeder       => true,
        :manage_flapjackfeeder_libdir => true
      } }
         
      it { should compile.with_all_deps }
          
      it { should contain_file('/usr/local/lib') }
      it { should contain_file('/usr/local/lib/flapjackfeeder.o') }
    end        
  end  
end
