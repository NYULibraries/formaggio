require File.join(File.dirname(__FILE__), '../../../lib', 'capistrano-nyu')

set :app_title, "rake_nyu"
set :branch, "devel"
set :scm, :git