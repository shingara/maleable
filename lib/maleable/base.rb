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
  end
end
