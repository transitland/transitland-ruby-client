module TransitlandClient
  class Entity
    def initialize(json)
      map_json(json)
    end

    def self.endpoint
      "#{self.to_s.split(':')[-1].downcase}s"
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
      raise ArgumentError if options[:onestop_id] && options.keys.length > 1

      found_objects = []
      entity_instances = TransitlandClient::Fetcher.get(endpoint, options)

      entity_instances.each do |entity|
        found_objects << new(entity)
      end

      return (options[:onestop_id]) ? found_objects.first : found_objects
    end

    def map_json(json)
      json.each do |key, value|
        instance_variable_set("@#{key}", json[key])
        self.class.class_eval { attr_reader key.to_sym }
      end
    end
  end
end
