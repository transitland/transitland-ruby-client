require 'git'
require 'singleton'
require 'fileutils'

module TransitlandClient
  class FeedRegistry
    include Singleton

    def self.repo(force_update: false)
      @remote_url ||= ENV['TRANSITLAND_FEED_REGISTRY_URL'] || 'https://github.com/transitland/transitland-feed-registry.git'
      @local_path ||= ENV['TRANSITLAND_FEED_REGISTRY_PATH'] || File.join(__dir__, '..', '..','tmp', 'transitland-feed-registry')

      if !defined?(@repo) || force_update
        begin
          FileUtils.mkdir_p(@local_path)

          @repo = Git.open(@local_path)
          @repo.pull if force_update
        rescue ArgumentError => error
          if error.message == 'path does not exist'
            @repo = Git.clone(@remote_url, @local_path)
          end
        end
      end

      @repo
    end

    def self.json_files_for_entity(entity)
      Dir[File.join(@local_path, entity, '**', '*.json')]
    end

    def self.json_file_for_entity_with_name(entity, name)
      File.join(@local_path, entity, "#{name}.json")
    end
  end
end
