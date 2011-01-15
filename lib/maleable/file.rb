module Maleable
  class File
    include Mongoid::Document
    include Mongoid::Timestamps
    field :name, :type => String
    field :gridfs_id, :type => BSON::ObjectId
  end
end
