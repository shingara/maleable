require 'spec_helper'

describe Maleable::Action do
  describe ".changed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.changed(nil).should == true
    end
    it 'should logged changed information in debug logger if a directory changed' do
      logger = double(:logger)
      Maleable::Base.config.logger = logger
      logger.should_receive(:debug).with("File ./ok changed")
      Maleable::Action.changed(['./ok'])
      Maleable::Base.config.logger = nil
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
      Maleable::Base.config.logger = nil
    end

    it 'should mark delete the Mongo object' do
      f = File.join(File.dirname(__FILE__), '../fixtures/typologo.gif')
      m = Maleable::File.create(:name => f)
      Maleable::Action.removed([f])
      m.reload.deleted_at.should_not be_nil
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
      logger.should_receive(:debug).with("File ./ok added")
      Maleable::Action.added(['./ok'])
      Maleable::Base.config.logger = nil
    end

  end
end
