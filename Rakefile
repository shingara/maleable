require "bundler"
Bundler.setup(:development)
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)

require "rake"
require "rspec"
require "rspec/core/rake_task"

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec
