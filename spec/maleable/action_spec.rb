require 'spec_helper'

describe Maleable::Action do
  describe ".changed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.changed(nil).should == true
    end
    it 'should logged changed information in debug logger if a directory changed' do
      logger = double(:logger)
      Maleable::Base.configure do |config|
        config.logger = logger
      end
      logger.should_receive(:debug).with("File ./ok changed")
      Maleable::Action.changed(['./ok'])
    end
  end

  describe ".removed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.removed(nil).should == true
    end

    it 'should logged removed information in debug logger if a directory removed' do
      logger = double(:logger)
      Maleable::Base.configure do |config|
        config.logger = logger
      end
      logger.should_receive(:debug).with("File ./ok removed")
      Maleable::Action.removed(['./ok'])
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
    end

  end
end
