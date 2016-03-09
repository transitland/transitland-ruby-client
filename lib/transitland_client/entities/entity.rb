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
        yield.tap do |response|
          TransitlandClient::Cache.set_entity(options[:onestop_id],response)
          return response
        end
      end
    end

    def self.find_by(options={})
      found_objects = []
      response = nil
      response = handle_caching(options) do
        HTTParty.get("#{base_path}#{endpoint}", query: options).body
      end
      parsed_json = JSON.parse(response)
      parsed_json[endpoint].each do |feed|
        found_objects << new(feed)
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
