module TransitlandClient
    
  class OptionList
    def initialize(options)
      lookup = { bbox: TransitlandClient::BoundingBox,
                 onestop_id: TransitlandClient::OnestopId
               }
               
      new_options = {}
      options.each do |key, value|
        new_options[key] = lookup[key].new(value) if lookup[key]
      end
      @options = options.merge(new_options)
    end

    def [](opt)
      return @options[opt]
    end

    def to_url
      url_options = {}
      @options.each do |opt,value|
        if value.class == String
          url_options[opt] = value
        else
          url_options[opt] = value.to_url
        end
      end
      return url_options
    end
  end

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
