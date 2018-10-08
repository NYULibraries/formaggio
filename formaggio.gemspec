$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "formaggio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "formaggio"
  s.version     = Formaggio::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scot.dalton@nyu.edu"]
  s.homepage    = "https://github.com/NYULibraries/formaggio"
  s.summary     = "Common deploy tasks for the NYU Libraries."
  s.description = "Common deploy tasks for the NYU Libraries."
  s.license     = 'MIT'

  s.files = Dir["lib/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rake", ">= 10.1"
  s.add_dependency "require_all", "~> 1.3"
  s.add_dependency "cap_git_tools", "~> 0.9"
  s.add_dependency "git", "~> 1.2"
  s.add_dependency "mail", "~> 2.5"
  s.add_dependency "capistrano", "~> 2.15"
  s.add_dependency "rvm-capistrano", "~> 1.5"
  s.add_dependency "newrelic_rpm", ">= 3.6"
  s.add_dependency "figs", "~> 2.0"

  s.add_development_dependency "rspec", "~> 2.14"
  s.add_development_dependency "pry", "~> 0.9.12"
end
