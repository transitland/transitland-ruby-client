require 'sqlite3'

module TransitlandClient
  class Cache
    FILENAME = "transitland.db"

    def initialize
      @db = SQLite::Database.open(FILENAME)
    end
  end
end
