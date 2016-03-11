#Gem.find_files("transitland_client/**/*.rb").each { |path| require path }
require 'httparty'
require 'transitland_client/onestop_id'
require 'transitland_client/cache'
require 'transitland_client/version'
require 'transitland_client/fetcher'

require 'transitland_client/entities/entity'
require 'transitland_client/entities/feed'
require 'transitland_client/entities/operator'
require 'transitland_client/entities/stop'

module TransitlandClient
end

puts "RESULTS #{TransitlandClient::Stop.find_by(bbox: '-80.0, 35.0,-73.0, 41.0')}"
