require 'logger'

module TransitlandClient
  class Log
    
    LOGFILE = "transitland.log"
   
    `rm #{LOGFILE}` if File.exist? LOGFILE
    @@logger = Logger.new LOGFILE
    @@logger.level = Logger::INFO
    @@logger.datetime_format = '%Y-%m-%d %H:%M:%S '
        
    def self.info(msg)
      @@logger.info msg
    end
  end
end