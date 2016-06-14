require 'byebug'
require 'pry-byebug'

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :console do
  require 'pry'
  require 'transitland_client'
  ARGV.clear
  Pry.start
end

task :make_changelog do
  `github_changelog_generator`
end

task default: :spec
