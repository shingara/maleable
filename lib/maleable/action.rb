module Maleable
  class Action
    def self.changed(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} changed")
      end
    end

    def self.removed(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} removed")
      end
    end

    def self.added(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} added")
      end
    end

  end
end
