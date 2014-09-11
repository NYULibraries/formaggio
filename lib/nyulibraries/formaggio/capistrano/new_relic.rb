# Include New Relic recipes
require 'new_relic/recipes'

Capistrano::Configuration.instance(:must_exist).load do
  before  "newrelic:notice_deployment", "newrelic:set"
  # After newrelic runs, reset up its yaml file
  after   "newrelic:notice_deployment", "newrelic:reset"
  after   "deploy:update",              "newrelic:notice_deployment"
  

  namespace :newrelic do
    def new_relic_environment?
      return false if fetch(:new_relic_environments).nil?
      fetch(:new_relic_environments).collect {|environment| environment.to_sym}.include?(fetch(:stage, fetch(:rails_env, :staging)).to_sym)
    end
    
    desc "Write New Relic file without ERB for processing by New Relic rpm recipe"
    task :set do
      if new_relic_environment?
        run_locally "bundle exec rake nyulibraries:deploy:newrelic:set RAILS_ENV=#{fetch(:rails_env, 'staging')}"
      end
    end

    desc "Reset the New Relic file"
    task :reset do
      if new_relic_environment?
        run_locally "bundle exec rake nyulibraries:deploy:newrelic:reset RAILS_ENV=#{fetch(:rails_env, 'staging')} "
      end
    end
  end
end
