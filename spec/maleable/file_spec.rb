require 'spec_helper'
describe Maleable::File do
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
end
