require 'spec_helper'

describe Maleable::Action do
  after(:each) do
    Maleable::Base.config.logger = nil
  end

  let(:file_to_save){
    File.join(File.dirname(__FILE__),
              '../fixtures/typologo.gif')
  }

  describe ".changed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.changed(nil).should == true
    end
    it 'should logged changed information in debug logger if a directory changed' do
      logger = double(:logger)
      Maleable::Base.config.logger = logger
      logger.should_receive(:debug).with("File #{file_to_save} changed")
      Maleable::Action.changed([file_to_save])
    end
  end

  describe ".removed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.removed(nil).should == true
    end

    it 'should logged removed information in debug logger if a directory removed' do
      logger = double(:logger)
      Maleable::Base.config.logger = logger
      logger.should_receive(:debug).with("File ./ok removed")
      Maleable::Action.removed(['./ok'])
    end

    it 'should mark delete the Mongo object' do
      m = Maleable::File.create(:name => file_to_save,
                               :updated_at => Time.now - 10,
                               :created_at => Time.now - 20)
      Maleable::Action.removed([file_to_save])
      m.reload.deleted_at.should_not be_nil
      m.updated_at.should be_within(1).of(m.deleted_at)
      Maleable::Base.gridfs.get(m.gridfs_id).should_not be_nil
    end
  end

  describe ".added" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.added(nil).should == true
    end

    it 'should logged added information in debug logger if a directory added' do
      logger = double(:logger)
      Maleable::Base.configure do |config|
        config.logger = logger
      end
      logger.should_receive(:debug).with("File #{file_to_save} added")
      Maleable::Action.added([file_to_save])
    end

    it 'should add the File on Gridfs' do
      Maleable::File.where(:name => file_to_save).destroy_all
      lambda do
        Maleable::Action.added(file_to_save)
      end.should change(Maleable::File, :count).by(1)
      m = Maleable::File.where(:name => file_to_save).first
      m.should_not be_nil
      m.gridfs_id.should_not be_nil
      Maleable::Base.gridfs.get(m.gridfs_id).should_not be_nil
    end

  end
end
