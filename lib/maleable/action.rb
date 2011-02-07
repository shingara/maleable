module Maleable
  class Action
    def self.changed(directory)
      return true unless directory
      directory = Maleable::File.without_base_dir(directory)
      Maleable::Base.config.logger.debug("File #{directory} changed") if Maleable::Base.config.logger
      Maleable::File.update_or_create(directory)
    end

    def self.removed(directory)
      return true unless directory
      directory = Maleable::File.without_base_dir(directory)
      Maleable::Base.config.logger.debug("File #{directory} removed") if Maleable::Base.config.logger
      f = Maleable::File.where(:name => directory).first
      f.delete if f
    end

    def self.added(directory)
      return true unless directory
      Maleable::Base.config.logger.debug("File #{directory} added") if Maleable::Base.config.logger
      Maleable::File.create!(:name => directory)
    end

  end
end
