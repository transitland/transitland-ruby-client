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
  
  class OptionList
    
    CLASS_OVERRIDES = { 
      bbox:       TransitlandClient::BoundingBox,
      onestop_id: TransitlandClient::OnestopId
    }
    
    def initialize(options)
      new_options = {}
      options.each do |key, value|
        new_options[key] = CLASS_OVERRIDES[key].new(value) if CLASS_OVERRIDES[key]
      end
      
      # Merge the enhanced options with the original string options
      @options = options.merge(new_options)
    end

    # Privde hash-like access to this class' options
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
end
