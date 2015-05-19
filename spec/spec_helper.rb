require 'byebug'
require 'pry-byebug'

require 'vcr'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

ENV['ONESTOP_ID_REGISTRY_LOCAL_PATH'] = File.join(__dir__, 'test_data', 'onestop-id-registry')

require 'onestop_id_client'

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/test_data/vcr_cassettes')
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:suite) do
    TransitlandClient::Registry.repo # pull down a local copy of the repo for use during the tests
  end
end
