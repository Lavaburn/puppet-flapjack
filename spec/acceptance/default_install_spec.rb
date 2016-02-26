require 'spec_helper_acceptance'

describe 'flapjack class' do
  let(:install_manifest) {
    <<-EOS
      class { '::flapjack': }
    EOS
  }
  
  let(:config_manifest) {
    <<-EOS
      #{install_manifest}    
      flapjack::config::base { 'production': 
        log_level => 'DEBUG',            
      }
      
      flapjack::config::redis { 'production': 
      
      }
      
      flapjack::config::processor { 'production': 
        log_level => 'DEBUG',         
      }  
      
      flapjack::config::notifier { 'production': 
        default_contact_timezone => 'CET',
        log_level                => 'DEBUG',      
      }
      
      flapjack::config::gateway::jsonapi { 'production': 
        port => 4081,
      }
      
      flapjack::config::gateway::web { 'production': 
        port    => 4080,
        api_url => 'http://localhost:4081/',
      }
      
      flapjack::config::gateway::email { 'production': 
        smtp_from   => 'test@example.com',
        smtp_domain => 'example.com',
        log_level   => 'DEBUG',
      }
      
      flapjack::config::gateway::jabber { 'production': 
        id           => 'jabberuser',
        password     => 'myPW',
        jabber_alias => 'flapjackuser',
        rooms        => ['public_alerts'],
      }
      
      flapjack::config::gateway::sms_twilio { 'production': 
        account_sid => '123456789',
        auth_token  => 'secretpass',
        from        => '+123456789',
      }
      
      class { 'flapjack::api':
        port => 4081,        
      }  
    EOS
  }
  
  let(:rest_manifest) {
    <<-EOS
      #{config_manifest}
      
      flapjack_contact { 'testuser':
        first_name => 'Test',
        last_name  => 'User',
        email      => 'test@example.com',
        timezone   => 'GMT',
      }
    
      flapjack_media { 'testuser_email':
        contact          => 'testuser',
        type             => 'email',
        address          => 'test@example.com',
        interval         => '60',
        rollup_threshold => '5',
      }
      
      flapjack_entity { 'TEST':

      }
      
      flapjack_notification_rule { 'testuser_rule1':
        contact  => 'testuser',
        entities => ['TEST'],
        tags     => ['myalert'],
      }    
    EOS
  }
  
  context 'first install' do
#    before { skip("Not testing this today") }

    it 'should install without errors and be idempotent' do  
      # Run without errors
      apply_manifest(install_manifest, :catch_failures => true)
      
      # Idempotency - no further changes..
      result = apply_manifest(install_manifest, :catch_failures => true)
      expect(result.exit_code).to be_zero
    end
    
    describe port(3080) do
      it { should be_listening }
    end
    
    describe port(3081) do
      it { should be_listening }
    end
  
    describe service('flapjack') do
      it { should be_running }
    end

    describe file('/etc/flapjack/flapjack_config.yaml') do
      it { should exist }
#      its(:content) { should match // }  => Need to parse it flat first...
    end
  end
  
  context 'configuration' do
  #    before { skip("Not testing this today") }
  
    it 'should configure without errors and be idempotent' do
      # Run without errors
      apply_manifest(config_manifest, :catch_failures => true)
        
      # Idempotency - no further changes..
      result = apply_manifest(config_manifest, :catch_failures => true)
      expect(result.exit_code).to be_zero
    end
    
    describe port(4080) do
      it { should be_listening }
    end
    
    describe port(4081) do
      it { should be_listening }
    end
  
    describe service('flapjack') do
      it { should be_running }
    end
    
    describe file('/etc/flapjack/flapjack_config.yaml') do
      it { should exist }
#      its(:content) { should match // }  => Need to parse it flat first...
    end
  end
  
  context 'REST API' do
  #    before { skip("Not testing this today") }
  
    it 'should configure without errors and be idempotent' do
      # Run without errors
      apply_manifest(rest_manifest, :catch_failures => true)
        
      # Idempotency - no further changes..
      result = apply_manifest(rest_manifest, :catch_failures => true)
      expect(result.exit_code).to be_zero
    end
  end
end