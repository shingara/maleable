module Maleable
  class Runner

    def self.run(directory)
      Dir.chdir(directory)
      update_from_remote(directory)
      push_update_in_local(directory)
      # Seems only return an hash not 3 variables
      # example : {:changed=>[], :removed=>["./ok"], :added=>[]}
      Vigilo::Watcher.watch(Dir.getwd) do |changed, added, deleted|
        Maleable::Action.changed(changed[:changed].map{|d| d.gsub(Dir.getwd + '/', '')})
        Maleable::Action.removed(changed[:removed].map{|d| d.gsub(Dir.getwd + '/', '')})
        Maleable::Action.added(changed[:added].map{|d| d.gsub(Dir.getwd + '/', '')})
      end
    end

    ##
    # Check all data from gridfs and download it in local
    #
    def self.update_from_remote(directory)
      c = 0
      Dir.glob('**/*') do |directory|
        # We don't need save directory
        unless ::File.directory?(directory)
          Maleable::Base.debug("file exists : #{directory}")
          Maleable::File.update_or_create(directory)
          c += 1
        end
      end
      Maleable::Base.debug("number of file check : #{c}")
    end

    ##
    # Check news of update in locale and push it on gridfs
    def self.push_update_in_local(directory)
    end

  end
end
