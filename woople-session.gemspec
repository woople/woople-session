# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "woople-session/version"

Gem::Specification.new do |s|
  s.name        = "woople-session"
  s.version     = Woople::Session::VERSION
  s.authors     = ["Cameron Westland"]
  s.email       = ["camwest@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{An easy way to login as a woople administrator}
  s.description = %q{Our internal session library}

  s.rubyforge_project = "woople-session"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.8"
  s.add_dependency 'activemodel', "~> 3.2.1"
  s.add_dependency 'ezcrypto'
end
