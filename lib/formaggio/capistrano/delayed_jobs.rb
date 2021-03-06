Capistrano::Configuration.instance(:must_exist).load do
  after "deploy", "delayed_jobs:restart"

  namespace :delayed_jobs do
    desc "Startup delayed jobs script"
    task :restart do
      run "cd #{current_path}; RAILS_ENV=#{rails_env} #{current_path}/bin/delayed_job restart -i '#{app_title}.#{rails_env}'"
    end
  end
end
