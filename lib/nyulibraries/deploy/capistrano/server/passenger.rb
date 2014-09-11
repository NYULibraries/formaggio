Capistrano::Configuration.instance(:must_exist).load do
  # Cleanup old deploys and set passenger symbolic link
  after "deploy", "deploy:passenger_symlink"
  
  namespace :deploy do
    desc "Start Application"
    task :start, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
      run "cd #{current_path}"
    end
    desc "Restart Application"
    task :restart, :roles => :app do
      run "touch #{current_path}/tmp/restart.txt"
      run "cd #{current_path}"
    end
    task :stop, :roles => :app do
      run "cd #{current_path}"
    end
    task :passenger_symlink do
      run "rm -rf #{fetch(:app_path, '~')}/#{fetch :app_title} && ln -s #{current_path}/public #{fetch(:app_path, '~')}/#{fetch :app_title}"
    end
  end
end













