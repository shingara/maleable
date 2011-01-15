module Maleable
  class File
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Versioning

    field :name, :type => String
    field :gridfs_id, :type => BSON::ObjectId

    validates_presence_of :name
    validates_uniqueness_of :name

  end
end
