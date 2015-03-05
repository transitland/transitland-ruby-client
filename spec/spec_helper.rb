require 'byebug'
require 'pry-byebug'

require 'vcr'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

# monkey patch
module OnestopIdClient
  class Registry
    include Singleton
    LOCAL_PATH = File.join(__dir__, '..', 'test_data', 'onestop-id-registry')
  end
end

require 'onestop_id_client'

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/test_data/vcr_cassettes')
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:suite) do
    OnestopIdClient::Registry.repo # pull down a local copy of the repo for use during the tests
  end
end
