require 'rspec'
require 'mongoid-rspec'
require 'maleable'


Maleable::Base.configure_database(:database => 'maleable_test')
Rspec.configure do |config|
  config.include Mongoid::Matchers
  config.before(:each) do
    Maleable::File.base_dir = File.expand_path(File.dirname(__FILE__))
    Maleable::File.name_dir = 'test'
    Mongoid.master.collections.select {|c| c.name !~ /fs|system/ }.each(&:drop)
    Mongoid.master.collections.select { |c| c.name =~ /fs/ }.each(&:remove)
  end
end
