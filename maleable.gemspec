# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "maleable/version"

Gem::Specification.new do |s|
  s.name        = "maleable"
  s.version     = Maleable::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Cyril Mougel"]
  s.email       = ["cyril.mougel@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A backup file synchronisation}
  s.description = %q{Save all file in GridFS}

  s.rubyforge_project = "maleable"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "fssm"
  s.add_dependency "mongo"
  s.add_dependency "bson"
  s.add_dependency "activesupport"
  s.add_dependency "eventmachine"
  s.add_dependency "mongoid", '>= 2.0.0.rc.4'

  s.add_development_dependency "rspec"
  #s.add_development_dependency "rspec_mock"
  s.add_development_dependency "mongoid-rspec-mongoid-rc"

end
