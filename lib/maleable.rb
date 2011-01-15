require 'vigilo'

require 'maleable/version'
require 'maleable/action'

module Maleable
  class Runner

    def self.run(directory)
      # Seems only return an hash not 3 variables
      # example : {:changed=>[], :removed=>["./ok"], :added=>[]}
      Vigilo::Watcher.watch(directory) do |changed, added, deleted|
        Maleable::Action.changed(changed[:changed])
        Maleable::Action.removed(changed[:removed])
        Maleable::Action.added(changed[:added])
      end
    end

  end
end
