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

    after_save :save_on_gridfs


    ##
    # Check if file exist or is changed from what there are on
    # gridfs.
    #
    # Create file is not exist, update it if needed
    #
    def self.update_or_create(file)
      m = Maleable::File.where(:name => file).first
      unless m
        Maleable::File.create(:name => file)
      else
        local_md5 = Digest::MD5.new
        local_md5.update(::File.read(m.name))
        unless local_md5.hexdigest == m.grid_io['md5']
          m.send :save_on_gridfs
        end
      end
    end

    def grid_io
      Maleable::Base.gridfs.get(self.gridfs_id)
    end

    private

    ##
    # Save file on gridfs and update the gridfs_id
    #
    def save_on_gridfs
      f = Maleable::Base.gridfs.put(::File.open(self.name))
      collection.update({:_id => self.id}, {'$set' => {:gridfs_id => f}})
      Maleable::Base.debug("Save on gridfs the file :#{self.name}")
    end

  end
end
