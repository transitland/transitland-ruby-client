require_relative 'feed'
# require_relative 'operator'

module TransitlandClient
  module Entities
    class OperatorInFeed
      attr_accessor :gtfs_agency_id, :operator_onestop_id, :feed_onestop_id, :feed, :identifiers

      def initialize(gtfs_agency_id: nil, operator_onestop_id: nil, feed_onestop_id: nil, feed: nil, identifiers: nil)
        if feed
          @feed = feed
        elsif feed_onestop_id
          @feed = Feed.new(onestop_id: feed_onestop_id)
        else
          raise ArgumentError.new('a feed object or Onestop ID must be specified')
        end

        @gtfs_agency_id = gtfs_agency_id
        @operator_onestop_id = operator_onestop_id
        @identifiers = identifiers || []

        self
      end
    end
  end
end
