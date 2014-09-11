# Load Bundler cap recipe
require "bundler/capistrano"

Capistrano::Configuration.instance(:must_exist).load do
  # After your bundle has installed, do any migrations
  after "bundle:install", "deploy:migrate"
  after "bundle:install", "bundle:clean"
  
  namespace :bundle do
    desc "Clear rails cache"
    task :clean do
      if bundle_cleaning_environments?
        run "cd #{current_release} && bundle clean"
      end
    end
  end
  
  def bundle_cleaning_environments?
    return true if fetch(:bundle_cleaning_environments).nil?
    fetch(:bundle_cleaning_environments).collect {|environment| environment.to_sym}.include?(fetch(:stage, fetch(:rails_env, :staging)).to_sym)
  end
end