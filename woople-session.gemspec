# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "woople-session/version"

Gem::Specification.new do |s|
  s.name        = "woople-session"
  s.version     = Woople::Session::VERSION
  s.authors     = ["Cameron Westland"]
  s.email       = ["camwest@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "woople-session"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.8"
end
