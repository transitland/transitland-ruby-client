module TransitlandClient
  class Entity
    
    def initialize(json)
      raise ArgumentError if json.class != Hash
      
      @json       = json
      @attributes = @json.keys.map { |key| key.to_sym }
    end

    def self.endpoint
      "#{self.to_s.split(':')[-1].gsub(/(.)([A-Z])/,'\1_\2').downcase}s"
    end
    
    def get(key)
      raise ArgumentError if key.class != Symbol
      raise ArgumentError if !@attributes.include?(key)
      return @json[key.to_s]
    end
    
    def get_attributes
      return @attributes
    end

    def self.find_by(options)
      raise ArgumentError if !options
      raise ArgumentError if options[:onestop_id] && options.keys.length > 1

      options = TransitlandClient::OptionList.new(options)
      found_objects = []
      entity_instances = Fetcher.get(endpoint, options)
      entity_instances.each do |entity|
        found_objects << new(entity)
      end
      
      return found_objects
    end
  end
  
  private_constant :Entity
end
