require 'onestop_id_client/version'
require 'onestop_id_client/onestop_id'
require 'onestop_id_client/registry'
Dir["entities/*.rb"].each {|file| require file }

module OnestopIdClient
  # Your code goes here...
end
