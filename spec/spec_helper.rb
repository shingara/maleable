require 'rspec'
require 'mongoid-rspec'
require 'maleable'


Maleable::Base.configure_database(:database => 'maleable_test')
Rspec.configure do |config|
  config.include Mongoid::Matchers
  config.before(:all) do
    Mongoid.master.collections.select {|c| c.name !~ /fs|system/ }.each(&:drop)
    Mongoid.master.collections.select { |c| c.name =~ /fs/ }.each(&:remove)
  end
end
