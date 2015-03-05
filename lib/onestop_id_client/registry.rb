require 'git'

module OnestopIdClient
  class Registry
    include Singleton

    REMOTE_URL = 'git@github.com:transitland/onestop-id-registry.git'
    LOCAL_PATH = File.join(__dir__, '..', '..','tmp', 'onestop-id-registry')

    def self.repo(force_update: false)
      if !defined?(@repo) || force_update
        begin
          @repo = Git.open(REMOTE_URL)
          @repo.pull if force_update
        rescue ArgumentError => error
          if error.message == 'path does not exist'
            @repo = Git.clone(REMOTE_URL, LOCAL_PATH)
          end
        end
      end

      # TODO: remove when this is complete: https://github.com/transitland/onestop-id-registry/pull/12
      @repo.branch("remotes/origin/extract-ruby").checkout

      @repo
    end

    def self.json_files_for_entity(entity)
      Dir[File.join(LOCAL_PATH, entity, '**', '*.json')]
    end
  end
end
