module TransitlandClient
  # Entity is the parent class for all API enpoints and contains
  # methods to fetch instances of its particular type from the
  # Transitland datastore, as well as access attributes of instances
  # of that endpoint
  class Entity
    
    # Create a new entity, storing its attributes and keys
    def initialize(json)
      raise TransitlandClient::EntityException if !json
      raise TransitlandClient::EntityException if json.class != Hash
      
      @json       = json
      @attributes = @json.keys.map { |key| key.to_sym }
    end

    # Define the endpoint for this entity type
    # For example, ScheduleStopPair becomes schedule_stop_pairs
    def self.endpoint
      "#{self.to_s.split(':')[-1].gsub(/(.)([A-Z])/,'\1_\2').downcase}s"
    end
    
    # Return the requested attribute, if this entity contains it
    def get(key)
      raise TransitlandClient::EntityException if key.class != Symbol
      raise TransitlandClient::EntityException if !@attributes.include?(key)
      return @json[key.to_s]
    end
    
    # Return the attributes of this entity
    def get_attributes
      return @attributes
    end

    # Provide a class method to search the API for objects of this
    # type based on a given set of inputs
    # Returns an array of matching results
    def self.find_by(options)
      raise TransitlandClient::EntityException if !options
      raise TransitlandClient::EntityException if options[:onestop_id] && options.keys.length > 1

      options = TransitlandClient::OptionList.new(options)
      found_objects = []
      entity_instances = Fetcher.get(endpoint, options)
      
      entity_instances.each do |entity|
        found_objects << new(entity)
      end
      
      return found_objects
    end
  end
  
  # Mark this class as private so that only its children can be created
  private_constant :Entity
end
