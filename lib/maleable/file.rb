module Maleable
  class File
    include Mongoid::Document
    include Mongoid::Timestamps
    include Mongoid::Versioning
    include Mongoid::Paranoia

    cattr_accessor :base_dir
    cattr_accessor :name_dir

    field :name_dir, :type => String
    field :name, :type => String
    field :gridfs_id, :type => BSON::ObjectId

    validates_presence_of :name_dir
    validates_presence_of :name
    validates_uniqueness_of :name, :scope => [:name_dir]

    after_save :save_on_gridfs
    before_validation :improve_name
    before_validation :define_name_dir

    def improve_name
      self.name = self.class.without_base_dir(self.name)
    end

    def self.without_base_dir(name)
      ::File.expand_path(name).gsub(/#{Regexp.escape(self.base_dir)}\/?/, '')
    end


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
          collection.update({:_id => m.id},
                            {'$set' => {:version => m.version + 1},
                             '$push' => {:versions => m.as_document}})

        end
      end
    end

    def grid_io
      Maleable::Base.gridfs.get(self.gridfs_id)
    end


    def write_on_disk(directory)
      FileUtils.cd(directory)
      ::FileUtils.mkdir_p(::File.dirname(self.name))
      ::FileUtils.touch(self.name)
      ::File.open(self.name, 'wb') do |fo|
        fo.write self.grid_io.read
      end
    end

    private

    ##
    # Save file on gridfs and update the gridfs_id
    #
    def save_on_gridfs
      FileUtils.cd(self.class.base_dir)
      f = Maleable::Base.gridfs.put(::File.open(self.name),
                                   :filename => self.name)
      collection.update({:_id => self.id}, {'$set' => {:gridfs_id => f}})
      Maleable::Base.debug("Save on gridfs the file : #{self.name}")
    end

    def define_name_dir
      self.name_dir ||= self.class.name_dir
    end

  end
end
