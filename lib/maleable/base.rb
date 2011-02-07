module Maleable
  class Base
    include ActiveSupport::Configurable
    cattr_accessor :gridfs

    def self.configure_database(conf)
      db = Mongo::Connection.new(nil, nil, :slave_ok => false).db(conf[:database])
      Mongoid.configure do |config|
        config.master = db
      end
      self.gridfs = Mongo::Grid.new(db)
    end

    # Print in debug level the text. Not print if no logger
    def self.debug(text)
      if config.logger
        config.logger.debug(text)
      end
    end

    # Print in info level the text. Not print if no logger
    def self.info(text)
      if config.logger
        config.logger.info(text)
      end
    end
  end
end
