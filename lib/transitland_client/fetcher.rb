require 'json'

module TransitlandClient
  class Entity
    module Fetcher
  
      BASE_PATH    = "https://transit.land/api/v1/"
      PER_PAGE_KEY = { per_page: 250 }

      # Get the requested API data, searching either by onestop_id
      # or any other arbitrary query. Caching will be performed so
      # that subsequent calls of this method will not require API calls  
      def self.get(endpoint, options)
        if options[:onestop_id]
          if entity = Cache.get_entity(options[:onestop_id].to_url)
            return [entity]
          else
            entity_instance = get_json_data_from_api(endpoint, options)
            
            # As we are only searching for a single entity, ensure that is all
            # we get from the API call
            raise ApiException if entity_instance.length != 1
            
            entity = entity_instance.first
            Cache.set_entity(options[:onestop_id].to_url, entity)
            return [entity]
          end
        else
          if entities = Cache.get_query(endpoint, options)
            return entities
          else
            entity_instances = get_json_data_from_api(endpoint, options)
            Cache.set_query(endpoint, options, entity_instances)
            return entity_instances
          end
        end
      end
     
      private 

      # Fetch JSON data from a given URL, save attributes with
      # a given field name, and handle pagination (Transitland-specific)
      def self.get_json_data_from_api(endpoint, options)
        data    = []
        
        options_url = options.to_url.merge(PER_PAGE_KEY)
        url         = "#{BASE_PATH}#{endpoint}"
  
        TransitlandClient::Log.info "Fetching URL: #{url} with options: #{options_url}"
        response = HTTParty.get(url, query: options_url)
        raise TransitlandClient::ApiException if !response[endpoint]
        
        results  = JSON.parse(response.body)
        data    += results[endpoint]
    
        while url = response["meta"]["next"] do
          TransitlandClient::Log.info "Fetching URL: #{url}"
          response = HTTParty.get(url)
          raise TransitlandClient::ApiException if !response[endpoint]
   
          results  = JSON.parse(response.body)
          data    += results[endpoint]
        end
        
        return data
      end
    end
    
    # Set this class as private to keep it an implementation detail of Entity
    private_constant :Fetcher
  end
end
