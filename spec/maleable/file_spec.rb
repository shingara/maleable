require 'spec_helper'
describe Maleable::File do
  it { should have_field(:name).of_type(String) }
  it { should have_field(:created_at).of_type(Time) }
  it { should have_field(:updated_at).of_type(Time) }
  it { should have_field(:gridfs_id).of_type(BSON::ObjectId) }
  it { should have_field(:version).of_type(Integer) }
  it { should embed_many(:versions) }
end
