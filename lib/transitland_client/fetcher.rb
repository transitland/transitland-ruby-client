require 'json'

module TransitlandClient
  module Fetcher

    BASE_PATH = "https://transit.land/api/v1/"

    def self.get(endpoint, options)
      if entity = TransitlandClient::Cache.get_entity(options[:onestop_id])
        return entity
      else
        entity_instances = get_json_data_from_api(endpoint, options)
        ransitlandClient::Cache.set_entity(entity_instances)
        return response
      end
    end
   
    private 
    #----------------------------------------------------
    # Fetch JSON data from a given URL, save attributes with
    # a given field name, and handle pagination (Transitland-specific)
    def self.get_json_data_from_api(endpoint, options)
      results = {}
      data    = []

      response = HTTParty.get("#{BASE_PATH}#{endpoint}", query: options)
      results  = JSON.parse(response.body)
      data    += results[endpoint]
  
      while url = response["meta"]["next"] do
        puts "URL #{url}"
 
        response = HTTParty.get(url)
        
        results  = JSON.parse(response.body)
        data    += results[endpoint]
      end
      
      return data
    end
  end
end
