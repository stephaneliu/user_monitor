$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "user_monitor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_monitor"
  s.version     = UserMonitor::VERSION
  s.authors     = ["Stephane Liu"]
  s.email       = ["sliu@sjliu.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of UserMonitor."
  s.description = "TODO: Description of UserMonitor."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.0"

  s.add_development_dependency "mysql2"
end
