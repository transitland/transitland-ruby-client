module TransitlandClient
  class BoundingBox
    attr_reader :coordinates
    def initialize(coordinates)
      throw ArgumentError if coordinates.class != String
      throw ArgumentError if coordinates.split(',').length != 4
      
      @coordinates = []
      
      coordinates.split(',').each do |c|
        @coordinates << c.to_f
      end
    end

    def to_url
      return @coordinates.join(',')
    end
    def to_cache_key
      return @coordinates.join(':')
    end
  end
end
