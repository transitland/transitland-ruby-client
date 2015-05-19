require 'byebug'
require 'pry-byebug'

require 'vcr'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end



require 'transitland_client'

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/test_data/vcr_cassettes')
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before(:each) do
    stub_const('ENV', ENV.to_hash.merge('TRANSITLAND_FEED_REGISTRY_LOCAL_PATH' => File.join(__dir__, 'test_data', 'transitland-feed-registry')))
    TransitlandClient::FeedRegistry.repo # set the URL/PATH variables
  end
end
