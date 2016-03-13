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
  end
end