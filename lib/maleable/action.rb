module Maleable
  class Action
    def self.changed(directories)
      return true unless directories
    end

    def self.removed(directories)
      return true unless directories
    end

    def self.added(directories)
      return true unless directories
    end

  end
end
