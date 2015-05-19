require 'git'
require 'singleton'

module TransitlandClient
  class FeedRegistry
    include Singleton

    REMOTE_URL = ENV['TRANSITLAND_FEED_REGISTRY_URL'] || 'git@github.com:transitland/transitland-feed-registry.git'
    LOCAL_PATH = ENV['TRANSITLAND_FEED_REGISTRY_PATH'] || File.join(__dir__, '..', '..','tmp', 'transitland-feed-registry')

    def self.repo(force_update: false)
      if !defined?(@repo) || force_update
        begin
          @repo = Git.open(LOCAL_PATH)
          @repo.pull if force_update
        rescue ArgumentError => error
          if error.message == 'path does not exist'
            @repo = Git.clone(REMOTE_URL, LOCAL_PATH)
          end
        end
      end

      @repo
    end

    def self.json_files_for_entity(entity)
      Dir[File.join(LOCAL_PATH, entity, '**', '*.json')]
    end

    def self.json_file_for_entity_with_name(entity, name)
      File.join(LOCAL_PATH, entity, "#{name}.json")
    end
  end
end
