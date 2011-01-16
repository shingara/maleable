module Maleable
  class Action
    def self.changed(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} changed") if Maleable::Base.config.logger
        f = Maleable::File.where(:name => directory).first
        f.name = directory
        f.save!
      end
    end

    def self.removed(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} removed") if Maleable::Base.config.logger
        f = Maleable::File.where(:name => directory).first
        f.delete if f
      end
    end

    def self.added(directories)
      return true unless directories
      directories.each do |directory|
        Maleable::Base.config.logger.debug("File #{directory} added") if Maleable::Base.config.logger
        Maleable::File.create!(:name => directory)
      end
    end

  end
end
