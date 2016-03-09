require 'json'

module TransitlandClient
  class Feed < Entity
  end
end
=begin
module TransitlandClient
  module Entities
    class Feed
      attr_accessor :onestop_id, :url, :feed_format, :tags, :operators_in_feed, :license

      def initialize(onestop_id: nil, json_blob: nil)
        if onestop_id
          begin
            json_file = File.open(FeedRegistry.json_file_for_entity_with_name('feeds', onestop_id), 'r')
            parsed_json = JSON.parse(json_file.read)
          rescue Errno::ENOENT
            raise ArgumentError.new("no JSON file found with a Onestop ID of #{onestop_id}")
          end
        elsif json_blob
          parsed_json = JSON.parse(json_blob)
        else
          raise ArgumentError.new('provide a Onestop ID or a JSON blob')
        end

        map_from_json_properties_to_object_variables(parsed_json)

        @parsed_json = parsed_json

        @operators_in_feed = create_operators_in_feed(@parsed_json['operatorsInFeed'])

        self
      end

      def self.find_by(onestop_id: nil, operator_identifier: nil, tag_key: nil, tag_value: nil)
        if onestop_id && (onestop_id_object = OnestopId.new(string: onestop_id))
          if onestop_id_object.entity_prefix == 'f'
            self.new(onestop_id: onestop_id)
          elsif onestop_id_object.entity_prefix == 'o'
            all.find_all { |feed| feed.operators_in_feed.any? { |oif| oif.operator_onestop_id ==  onestop_id } }
          end
        elsif tag_key && tag_value
          all.find_all { |feed| feed.tags[tag_key] == tag_value }
        elsif operator_identifier
          all.find_all { |feed| feed.operators_in_feed.any? { |oif| oif.identifiers.include?(operator_identifier) } }
        else
          raise ArgumentError.new('must specify a Onestop ID, a tag key and value, or an operator identifier.')
        end
      end

      def self.all(force_reload: false)
        if force_reload || !defined?(@entity_objects)
          @entity_objects = []
          files = FeedRegistry.json_files_for_entity('feeds')
          files.each do |file_path|
            json_file = File.open(file_path, 'r')
            @entity_objects << new(json_blob: json_file.read)
          end
        end
        @entity_objects
      end

      private

      def create_operators_in_feed(parsed_json_array)
        array = parsed_json_array.map do |parsed_json_object|
          OperatorInFeed.new(
            feed: self,
            operator_onestop_id: parsed_json_object['onestopId'],
            gtfs_agency_id: parsed_json_object['gtfsAgencyId'],
            identifiers: parsed_json_object['identifiers']
          )
        end
        array
      end

      def map_from_json_properties_to_object_variables(parsed_json)
        [
          ['@onestop_id', 'onestopId'],
          ['@url', 'url'],
          ['@feed_format', 'feedFormat'],
          ['@tags', 'tags'],
          ['@license', 'license']
        ].each do |mapping|
          instance_variable_set(mapping[0], parsed_json[mapping[1]])
        end
      end
    end
  end
end
=end
