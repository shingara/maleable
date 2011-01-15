require 'spec_helper'

describe Maleable::Action do
  describe ".changed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.changed(nil).should == true
    end
  end

  describe ".removed" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.removed(nil).should == true
    end
  end

  describe ".added" do
    it 'should do nothing if nil pass like args' do
      Maleable::Action.added(nil).should == true
    end
  end
end
