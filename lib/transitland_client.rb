#Dir.glob("transitland_client/**/*.rb").each { |path| require path }

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
require 'transitland_client/entities/schedule_stop_pair'

module TransitlandClient
end

#puts "RESULTS #{TransitlandClient::Stop.find_by(bbox: '-78.0, 39.0,-75.0, 41.0').length}"
puts "RESULTS #{TransitlandClient::ScheduleStopPair.find_by(bbox: '-78.0, 39.0,-75.0, 41.0',
                                                            date: '2016-03-16',
                                                            origin_departure_between: '07:30:00,08:00:00').length}"
#https://transit.land/api/v1/schedule_stop_pairs?bbox=-78.0,%2039.0,-75.0,%2041.0&date=2016-03-16&origin_departure_between=07:30:00,08:00:00
#puts "SECOND #{TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').onestop_id}"
