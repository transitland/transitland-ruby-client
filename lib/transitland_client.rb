#Gem.find_files("transitland_client/**/*.rb").each { |path| require path }
require 'httparty'
require 'transitland_client/onestop_id'
require 'transitland_client/cache'
require 'transitland_client/version'
require 'transitland_client/fetcher'
require 'transitland_client/inputs'
require 'transitland_client/errors'

require 'transitland_client/entities/entity'
require 'transitland_client/entities/feed'
require 'transitland_client/entities/operator'
require 'transitland_client/entities/stop'

module TransitlandClient
end

#puts "RESULTS #{TransitlandClient::Stop.find_by(bbox: '-78.0, 39.0,-75.0, 41.0').length}"
#puts "SECOND #{TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltain').onestop_id}"
