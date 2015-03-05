require 'byebug'
require 'pry-byebug'

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :console do
  require 'pry'
  require 'onestop_id_client'
  ARGV.clear
  Pry.start
end

task :default => :spec
