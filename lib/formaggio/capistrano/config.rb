require 'figs'

Capistrano::Configuration.instance(:must_exist).load do
  # Set the servers from rails config before we see
  # what's in the rails config environment
  before  "deploy",                             "config:see"
  before  "deploy:cold",                        "config:see"
  before  "deploy:setup",                       "config:see"
  before  "deploy:check",                       "config:see"
  before  "deploy:assets:update_asset_mtimes",  "config:see"
  before  "config:see",                         "figs:load_"
  
  namespace :config do
    # desc "Set stage variables"
    task :set_variables do
      # Configure app_settings from config
      # Defer processing until we have rails environment
      
      set(:app_settings, true)
      set(:scm_username, ENV['DEPLOY_SCM_USERNAME'])
      set(:app_path, ENV['DEPLOY_PATH'])
      set(:user, ENV['DEPLOY_USER'])
      set(:puma_ports, Figs::ENV.puma_ports)
      set(:deploy_to)     {"#{fetch :app_path}#{fetch :application}"}
    end

    # desc "Set servers"
    task :set_servers do
      if Figs::ENV.deploy_servers.is_a?(Array)
        Figs.env.deploy_servers.each_with_index do |deploy_server, index|
          primary_flag = (index === 0)
          server deploy_server, :app, :web, :db, primary: primary_flag
        end
      else
          server ENV['deploy_servers'], :app, :web, :db, :primary => true
      end
    end

    desc "See configuration settings"
    task :see do
      if !exists?(:app_settings)
        set_variables
        set_servers
        p "Variables now set."
        p "Servers: #{find_servers}"
        p "SCM Username: #{fetch :scm_username}"
        p "App Path: #{fetch :app_path}"
        p "User: #{fetch :user}"
        p "Deploy To: #{fetch :deploy_to}"
        p "Current path: #{current_path}"
        p "Puma ports: #{fetch :puma_ports, ''}"
      else
        p "Variables already set."
      end
    end
  end
end
