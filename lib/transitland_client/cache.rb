require 'sqlite3'
require 'singleton'

module TransitlandClient
  class Cache
    include Singleton

    FILENAME = "transitland.db"

    @@db = SQLite3::Database.open(FILENAME)

    def self.get_entity(id)
      create_entity_table if !entity_table_exists?
     
      return look_for_entity(id)
    end

    def self.set_entity(id, entity)
      @@db.execute("INSERT INTO entities (onestop_id, entity) VALUES (?,?)", [id, entity])
    end

    private

      def self.entity_table_exists?
        return @@db.execute("SELECT * FROM sqlite_master WHERE name='entities' and type='table'").length > 0
      end

      def self.create_entity_table
        return @@db.execute("CREATE TABLE entities(onestop_id varchar(50) primary key, entity blob)")
      end

      def self.look_for_entity(id)
        results = @@db.execute("SELECT * FROM entities WHERE onestop_id=?", [id])
        return (results.length == 0) ? nil : results[0][1]
      end
  end
end
