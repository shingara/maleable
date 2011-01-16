module Maleable
  class File
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Versioning
    include Mongoid::Paranoia


    field :name, :type => String
    field :gridfs_id, :type => BSON::ObjectId

    validates_presence_of :name
    validates_uniqueness_of :name

    after_create :save_on_gridfs

    def save_on_gridfs
      f = Maleable::Base.gridfs.put(::File.open(self.name))
      collection.update({:_id => self.id}, {'$set' => {:gridfs_id => f}})
    end

  end
end
