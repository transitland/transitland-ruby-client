require 'sqlite3'
require 'singleton'

module TransitlandClient
  class Cache
    include Singleton

    FILENAME = "transitland.db"

    @@db = SQLite3::Database.open(FILENAME)

    def self.get_entity(onestop_id)
      create_entity_table if !table_exists?(:entities)
      if entity = look_for_entity(onestop_id)
        return JSON.parse(entity)
      else
        return nil
      end
    end

    def self.set_entity(onestop_id, entity)
      create_entity_table if !table_exists?(:entities)
      @@db.execute("INSERT INTO entities (onestop_id, entity) VALUES (?,?)", [onestop_id, JSON.generate(entity)])
    end
    
    def self.get_query(endpoint, options)
      create_queries_table if !table_exists?(:queries)
      
      if onestop_ids = look_for_query(endpoint, options)
        entities = []
        onestop_ids.each do |onestop_id|
          entities << get_entity(onestop_id)
        end
        return entities
      else
        return nil
      end
    end
    
    def self.set_query(endpoint, options, entities)
      create_queries_table if !table_exists?(:queries)
      entities.each do |entity|
        onestop_id = (endpoint == "schedule_stop_pairs") ? "#{entity["origin_onestop_id"]}:#{entity["destination_onestop_id"]}" : entity["onestop_id"]
        @@db.execute("INSERT INTO queries (query_id, onestop_id) VALUES (?,?)", [generate_query_id(endpoint, options), onestop_id])
        if !get_entity(onestop_id)
          set_entity(onestop_id, entity)
        end
      end
    end

    private
    
      OPTIONS = [ :bbox,
                  :date,
		              :time_frame ]
    
      def self.generate_query_id(endpoint, options)
        query_id = endpoint
        OPTIONS.each do |option|
          if options[option]
            if options[option].class == String
              query_id += ";" + options[option]
            else
              query_id += ";" + options[option].to_cache_key
            end
          end
        end
        
        return query_id
      end

      def self.table_exists?(table_name)
        return @@db.execute("SELECT * FROM sqlite_master WHERE name='#{table_name.to_s}' and type='table'").length > 0
      end

      def self.create_entity_table
        @@db.execute("CREATE TABLE entities(onestop_id varchar(50) primary key, entity blob)")
      end
      
      def self.create_queries_table
        @@db.execute("CREATE TABLE queries(query_id varchar(200), onestop_id varchar(50))")
      end

      def self.look_for_entity(id)
        results = @@db.execute("SELECT entity FROM entities WHERE onestop_id=?", [id])
        raise "Only one entity expected." if results.length > 1
        return (results.length == 0) ? nil : results[0][0]
      end
      
      def self.look_for_query(endpoint, options)
        onestop_ids = @@db.execute("SELECT onestop_id FROM queries WHERE query_id=?", generate_query_id(endpoint, options))
        return nil if !onestop_ids[0] || !onestop_ids[0][0]
        
        return onestop_ids
      end
  end
end
