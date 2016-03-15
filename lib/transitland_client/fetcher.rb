require 'json'

module TransitlandClient
  module Fetcher

    BASE_PATH = "https://transit.land/api/v1/"

    def self.get(endpoint, options)
      if options[:onestop_id]
        if entity = TransitlandClient::Cache.get_entity(options[:onestop_id].to_url)
          return entity
        else
          entity_instance = get_json_data_from_api(endpoint, options)
          TransitlandClient::Cache.set_entity(options[:onestop_id].to_url, entity_instance)
          return entity_instance
        end
      else
        if entities = TransitlandClient::Cache.get_query(endpoint, options)
          return entities
        else
          entity_instances = get_json_data_from_api(endpoint, options)
          TransitlandClient::Cache.set_query(endpoint, options, entity_instances)
          return entity_instances
        end
      end
    end
   
    private 
    #----------------------------------------------------
    # Fetch JSON data from a given URL, save attributes with
    # a given field name, and handle pagination (Transitland-specific)
    def self.get_json_data_from_api(endpoint, options)
      data    = []

      response = HTTParty.get("#{BASE_PATH}#{endpoint}", query: options.to_url)
      puts "RESPONSE #{response}"
      raise TransitlandClient::ApiException if !response[endpoint]
      results  = JSON.parse(response.body)
      data    += results[endpoint]
  
      while url = response["meta"]["next"] do
 
        response = HTTParty.get(url)
        
        results  = JSON.parse(response.body)
        data    += results[endpoint]
      end
      
      return data
    end
  end
end
