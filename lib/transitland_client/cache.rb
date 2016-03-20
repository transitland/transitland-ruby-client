require 'sqlite3'
require 'singleton'

module TransitlandClient
  class Entity
    class Cache
      include Singleton
  
      FILENAME = "transitland.db"
  
      @@db = SQLite3::Database.open(FILENAME)
      @@db.execute("PRAGMA synchronous = OFF")
      @@db.execute("PRAGMA journal_mode = MEMORY")
  
      def self.get_entity(onestop_id)
        create_entities_table if !entities_table_exists?
        
        if entity = look_for_entity(onestop_id)
          return JSON.parse(entity)
        else
          return nil
        end
      end
  
      def self.set_entity(onestop_id, entity)
        create_entities_table if !entities_table_exists?
        
        TransitlandClient::Log.info "Caching entity #{onestop_id}"
        raise TransitlandClient::DatabaseException if entity.class != Hash
        @@db.prepare("INSERT INTO entities (onestop_id, entity) VALUES (?,?)").execute(onestop_id, JSON.generate(entity))
      end
      
      def self.get_query(endpoint, options)
        create_queries_table if !queries_table_exists?
        
        if onestop_ids = look_for_query(endpoint, options)
          entities = []
          
          @@db.execute("BEGIN TRANSACTION")
          onestop_ids.each_with_index do |onestop_id, i|
            TransitlandClient::Log.info "Retrieving #{endpoint} #{i+1} of #{onestop_ids.length}"
            entities << get_entity(onestop_id)
          end
          @@db.execute("END TRANSACTION")
          return entities
        else
          return nil
        end
      end
      
      def self.set_query(endpoint, options, entities)
        create_queries_table if !queries_table_exists?
        
        @@db.execute("BEGIN TRANSACTION")
        entities.each_with_index do |entity,i|
  
          # FIXME this sucks. Move it into the entity class *somehow*
          onestop_id = (endpoint == "schedule_stop_pairs") ? "#{entity["origin_onestop_id"]}:#{entity["destination_onestop_id"]}:#{entity["route_onestop_id"]}:#{entity["origin_departure_time"]}" : entity["onestop_id"]
          TransitlandClient::Log.info "Caching #{endpoint} #{i+1} of #{entities.length}"
          TransitlandClient::Log.info "--#{generate_query_id(endpoint, options)}, #{onestop_id}"
          @@db.execute("INSERT INTO queries (query_id, onestop_id) VALUES (?,?)", [generate_query_id(endpoint, options), onestop_id])
          if !get_entity(onestop_id)
            set_entity(onestop_id, entity)
          end
        end
        @@db.execute("END TRANSACTION")
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
  
        def self.entities_table_exists?
          if @entities_table
            return true
          else
            return @@db.execute("SELECT * FROM sqlite_master WHERE name='entities' and type='table'").length > 0
          end
        end
       
        def self.create_entities_table
          @@db.execute("CREATE TABLE entities(onestop_id varchar(50), entity blob, PRIMARY KEY(onestop_id))")
          @entities_table = true
        end
        
        def self.queries_table_exists?
          if @queries_table
            return true
          else
            return @@db.execute("SELECT * FROM sqlite_master WHERE name='queries' and type='table'").length > 0
          end
        end
        
        def self.create_queries_table
          #@@db.execute("CREATE TABLE queries(query_id varchar(200), onestop_id varchar(50), PRIMARY KEY(query_id, onestop_id))")
          @@db.execute("CREATE TABLE queries(query_id varchar(200), onestop_id varchar(50))")
          @queries_table = true
        end
  
        def self.look_for_entity(id)
          stmt = @@db.prepare("SELECT entity FROM entities WHERE onestop_id=?")
          stmt.bind_params(id)
          results = stmt.execute.to_a
          raise "Only one entity expected." if results.length > 1
          return (results.length == 0) ? nil : results[0][0]
        end
        
        def self.look_for_query(endpoint, options)
          onestop_ids = @@db.execute("SELECT onestop_id FROM queries WHERE query_id=?", generate_query_id(endpoint, options))
          return nil if !onestop_ids[0] || !onestop_ids[0][0]
          
          return onestop_ids
        end
        
      end
    
      # Set this class as private to keep it an implementation detail of Entity  
      private_constant :Cache
  end
end
