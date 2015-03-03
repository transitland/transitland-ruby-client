require 'byebug'
require 'pry-byebug'

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require_relative 'lib/onestop_id_client'

task :console do
  require 'pry'
  ARGV.clear
  Pry.start
end

task :default => :spec