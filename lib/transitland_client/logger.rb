require 'logger'

module TransitlandClient
  class Log
    
    @@logger = Logger.new 'tl.log'
    @@logger.level = Logger::INFO
    @@logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        
    def self.info(msg)
      @@logger.info msg
    end
  end
end