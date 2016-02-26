require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
#require 'helpers/exported_resources'
require 'coveralls'

Coveralls.wear!

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
  
#RSpec.configure do |c|
#  c.hiera_config = File.join(fixture_path, 'hiera/hiera.yaml')
  
#  c.before do
    # avoid "Only root can execute commands as other users"
#    Puppet.features.stubs(:root? => true)
#  end
#end

# Common code for (most) spec tests
RSpec.configure do |c|
#  c.before do 
#    @flapjack_common =
#      "class { 'flapjack':
#
#      }
#      "
#  end
end