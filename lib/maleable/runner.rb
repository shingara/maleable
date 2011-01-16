module Maleable
  class Runner

    def self.run(directory)
      update_from_remote(directory)
      push_update_in_local(directory)
      # Seems only return an hash not 3 variables
      # example : {:changed=>[], :removed=>["./ok"], :added=>[]}
      Vigilo::Watcher.watch(directory) do |changed, added, deleted|
        Maleable::Action.changed(changed[:changed])
        Maleable::Action.removed(changed[:removed])
        Maleable::Action.added(changed[:added])
      end
    end

    ##
    # Check all data from gridfs and download it in local
    #
    def self.update_from_remote(directory)
    end

    ##
    # Check news of update in locale and push it on gridfs
    def self.push_update_in_local(directory)
    end

  end
end
