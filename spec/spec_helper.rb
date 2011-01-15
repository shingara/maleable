require 'rspec'
require 'mongoid-rspec'
require 'maleable'

Mongoid.configure do |config|
  name = "maleable_test"
  config.master = Mongo::Connection.new.db(name)
  config.logger = nil
end


Rspec.configure do |config|
  config.include Mongoid::Matchers
  config.before(:all) do
    Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
  end
end
