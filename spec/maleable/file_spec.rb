require 'spec_helper'
describe Maleable::File do

  after {
    FileUtils.rm_f('tmp_file')
  }

  let(:file_to_save){
    File.join(File.dirname(__FILE__),
              '../fixtures/typologo.gif')
  }
  let(:maleable_file) { Maleable::File.create(:name => file_to_save) }
  let(:file_db) { Maleable::Base.gridfs.instance_variable_get(:@files) }

  it { should have_field(:name).of_type(String) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:gridfs_id).of_type(BSON::ObjectId) }
  it { should have_field(:version).of_type(Integer) }
  it { should have_field(:deleted_at).of_type(Time) }

  it { should embed_many(:versions) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe "Save in GridFS in after_create" do
    it 'should add file in GridFS and get id in object' do
      m = Maleable::File.new(:name => File.join(File.dirname(__FILE__),
                                               '../fixtures/typologo.gif'))
      m.gridfs_id.should be_nil
      m.save
      m.reload.gridfs_id.should_not be_nil
      Maleable::Base.gridfs.get(m.gridfs_id).should_not be_nil
    end
  end

  describe ".update_or_create" do
    it 'should do nothing if file already exist and is the same in md5' do
      maleable_file
      lambda do
        lambda do
          Maleable::File.update_or_create(file_to_save)
        end.should_not change(Maleable::File, :count)
      end.should_not change(file_db, :count)
    end

    it 'should create file if not exist previous' do
      lambda do
        lambda do
          Maleable::File.update_or_create(file_to_save)
        end.should change(Maleable::File, :count).by(1)
      end.should change(file_db, :count).by(1)
    end

    it 'should update file if file is not the same in md5 but same name' do
      File.open('tmp_file', 'w') do |f|
        f.write 'hello'
      end
      Maleable::File.create(:name => 'tmp_file')
      File.open('tmp_file', 'w') do |f|
        f.write 'h'
      end
      lambda do
        lambda do
          Maleable::File.update_or_create('tmp_file')
        end.should_not change(Maleable::File, :count).by(1)
      end.should change(file_db, :count).by(1)
    end
  end
end
