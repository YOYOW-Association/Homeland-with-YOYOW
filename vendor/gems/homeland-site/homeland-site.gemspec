$:.push File.expand_path("../lib", __FILE__)

require "homeland/site/version"

Gem::Specification.new do |s|
  s.name        = "homeland-site"
  s.version     = Homeland::Site::VERSION
  s.authors     = ["Jason Lee"]
  s.email       = ["huacnlee@gmail.com"]
  s.homepage    = "https://github.com/ruby-china/homeland-site"
  s.summary     = "Site plugin for Homeland"
  s.description = Homeland::Site::DESCRIPTION
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5"
end
