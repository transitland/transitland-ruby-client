#Gem.find_files("transitland_client/**/*.rb").each { |path| require path }
require 'httparty'
require 'transitland_client/onestop_id'
require 'transitland_client/cache'
require 'transitland_client/version'

require 'transitland_client/entities/entity'
require 'transitland_client/entities/feed'
require 'transitland_client/entities/operator_in_feed'

module TransitlandClient
end
