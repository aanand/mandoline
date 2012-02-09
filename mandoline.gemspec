# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mandoline/version"

Gem::Specification.new do |s|
  s.name        = "mandoline"
  s.version     = Mandoline::VERSION
  s.authors     = ["Aanand Prasad"]
  s.email       = ["aanand.prasad@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Delete Cucumber features by tag}

  s.rubyforge_project = "mandoline"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.8.0"
  s.add_development_dependency "rake",  "~> 0.9.2"
end
