require 'spec_helper_acceptance'

describe 'flapjack class' do
	describe 'running puppet code' do
    	it 'should work with no errors' do
      		pp = <<-EOS
      		  class { '::flapjack': }
      		  flapjack::config::base { 'dev': }
            flapjack::config::redis { 'dev': }
            flapjack::config::processor { 'dev': }  
            flapjack::config::notifier { 'dev': }
            flapjack::config::gateway::email { 'dev': }
      		EOS

      		# Run it twice and test for idempotency
      		apply_manifest(pp, :catch_failures => true)
      		
      		expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      		
      		# TODO - test service running without issue?
      		# TODO - compare the config file
      	end
    end
end