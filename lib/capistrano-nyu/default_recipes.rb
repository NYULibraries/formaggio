# Requiring Capistrano for recipes.
require 'capistrano'

# The default attributes get set here.
require_relative 'defaults'
# This loads a recipe for precompiling assets, this specific one only precompiles if there are any changes.
require_relative 'assets'
# This recipe clears the cache.
require_relative 'cache'
# The rails config recipe loads up all our application specific settings from a settings.yaml
require_relative 'rails-config'
# This recipe sends the git diff between two commits.
require_relative 'send-diff'
# The rvm recipe sets up an rvm environment with ruby.
require_relative 'rvm'
# The default server to use for this recipe is passenger.
require_relative 'server/passenger'