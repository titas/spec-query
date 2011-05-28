# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "spec_query/version"

Gem::Specification.new do |s|
  s.name        = "spec_query"
  s.version     = SpecQuery::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Titas Norkūnas"]
  s.email       = ["titas.norkunas@gmail.com"]
  s.homepage    = "http://www.assembla.com/profile/titas.norkunas"
  s.summary     = %q{Run specs by keywords they contain}
  s.description = %q{This is a small utility to query specs for Ruby on Rails projects}

  s.rubyforge_project = "spec_query"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

