module TransitlandClient
  class Entity
    def self.base_path
      "https://transit.land/api/v1/"
    end
    def self.endpoint
      "#{self.to_s.split(':')[-1].downcase}s"
    end
    def initialize(json)
      map_json(json)
    end

    def self.handle_caching(options)
      if entity = TransitlandClient::Cache.get_entity(options[:onestop_id])
        return entity
      else
        TransitlandClient::Fetcher.get_json_data_from_api("#{base_path}#{endpoint}", query: options)
          TransitlandClient::Cache.set_entity(options[:onestop_id],response)
          return response
      end
    end

    def self.find_by(options)
      raise ArgumentError if !options

      found_objects = []
      entity_instances = TransitlandClient::Fetcher.get(endpoint, options)
      entity_instances.each do |entity|
        found_objects << new(entity)
      end

      if options[:onestop_id]
        return found_objects.first
      else
        return found_objects
      end
    end

    def map_json(json)
      json.each do |key, value|
        instance_variable_set("@#{key}", json[key])
        self.class.class_eval { attr_reader key.to_sym }
      end
    end
  end
end
