require 'eventmachine'
module Maleable
  class Runner

    def self.run(directory)
      Dir.chdir(directory)
      Maleable::File.base_dir = directory
      update_from_remote(directory)
      push_update_in_local(directory)
      # Seems only return an hash not 3 variables
      # example : {:changed=>[], :removed=>["./ok"], :added=>[]}

      EM.run do
        child_id = EM.fork_reactor do
          trap('INT') { exit }
          trap('KILL') { exit }
          Vigilo::Watcher.watch(Dir.getwd) do |changed, added, deleted|
            Maleable::Action.changed(changed[:changed].map{|d| d.gsub(Dir.getwd + '/', '')})
            Maleable::Action.removed(changed[:removed].map{|d| d.gsub(Dir.getwd + '/', '')})
            Maleable::Action.added(changed[:added].map{|d| d.gsub(Dir.getwd + '/', '')})
          end
        end
        Process.detach(child_id)
        trap('INT') { print "\rQUIT\n"; Process.kill("INT", child_id); exit }
        trap('KILL') { print "\rQUIT\n"; Process.kill("KILL", child_id); exit }

        EventMachine::PeriodicTimer.new(5) do
          p 'watch'
        end
      end
      p 'exit'
    end

    ##
    # Check all data from gridfs and download it in local
    #
    def self.update_from_remote(directory)
      c = 0
      # be sure we are in good directory
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
      Maleable::Base.info("Download from server...")
      Maleable::File.all.each do |f|
        unless ::File.exists?(f.name)
          f.write_on_disk(directory)
          Maleable::Base.debug("Write file : #{f.name}")
        end
      end
    end

  end
end
