Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    desc "Start the application"
    task :start do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake nyulibraries:deploy:puma:start[#{port}]"
      end
    end
  
    desc "Stop the application"
    task :stop do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake nyulibraries:deploy:puma:stop[#{port}]"
      end
    end
  
    desc "Restart the application"
    task :restart, :roles => :app, :except => { :no_release => true } do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake nyulibraries:deploy:puma:restart[#{port}]"
      end
    end
  end
end