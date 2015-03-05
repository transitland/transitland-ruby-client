require 'byebug'
require 'pry-byebug'

require 'vcr'
require 'webmock/rspec'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec' # ignore spec files
end

require 'onestop_id_client'

VCR.configure do |c|
  c.cassette_library_dir = File.join(File.dirname(__FILE__), '/test_data/vcr_cassettes')
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
