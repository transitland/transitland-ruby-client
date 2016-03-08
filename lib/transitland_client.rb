Gem.find_files("transitland_client/**/*.rb").each { |path| require path }
require 'httparty'
require_relative 'transitland_client/cache.rb'

module TransitlandClient

  class Entity
#    base_uri 'https://transit.land'
    def self.base_path
      "https://transit.land/api/v1/"
    end
  end

  class Feed < Entity
    attr_accessor :entity_objects,:onestop_id, :url, :feed_format, :tags, :operators_in_feed, :license

    def initialize(json)
      map_json(json)
    end

    def self.handle_caching(options)
      if entity = TransitlandClient::Cache.get_entity(options[:onestop_id])
        puts " GETTING FROM CACHE"
        return entity
      else
        yield.tap do |response|
          puts "GOT FROM API"
          TransitlandClient::Cache.set_entity(options[:onestop_id],response)
          return response
        end
      end
    end

    def self.find_by(options={})
      @entity_objects ||= []
      response = nil
      response = handle_caching(options) do
        HTTParty.get(base_path + "feeds", query: options).body
      end
      parsed_json = JSON.parse(response)
      parsed_json["feeds"].each do |feed|
        @entity_objects << new(response)
      end

      return @entity_objects
    end

    def map_json(json)
              [
          ['@onestop_id', 'onestop_id'],
          ['@url', 'url'],
          ['@feed_format', 'feed_format'],
          ['@tags', 'tags'],
          ['@license', 'license']
        ].each do |mapping|
          instance_variable_set(mapping[0], json[mapping[1]])
        end
    end
  end
end

puts "Hello world #{TransitlandClient::Feed.find_by(onestop_id: "f-9q9-caltrain")}"
puts "Hello world #{TransitlandClient::Feed.find_by(onestop_id: "f-9q9-caltrain")}"
