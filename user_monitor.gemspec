$:.push File.expand_path("../lib", __FILE__)
require "user_monitor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "user_monitor"
  s.version     = UserMonitor::VERSION
  s.authors     = ["Stephane Liu"]
  s.email       = ["sliu@sjliu.com"]
  s.homepage    = "https://github.com/stephaneliu/user_monitor"
  s.summary     = "Updates created_by and updated_by fields for Active Record"
  s.description = "Monitors Active Record saves and updates to update created_by and updated_by fields with current_user"
  s.license     = "MIT"
  s.files       = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files  = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_development_dependency "mysql2"
end
