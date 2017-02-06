Capistrano::Configuration.instance(:must_exist).load do
  namespace :deploy do
    def puma_args(port)
      "#{port}#{fetch(:puma_ssl_enabled, false) ? ",'ssl'" : ""},#{fetch(:puma_threads, '2:4')}"
    end
    
    desc "Start the application"
    task :start do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake formaggio:puma:start[#{puma_args(port)}]"
      end
    end

    desc "Stop the application"
    task :stop do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake formaggio:puma:stop[#{puma_args(port)}]"
      end
    end

    desc "Restart the application"
    task :restart, :roles => :app, :except => { :no_release => true } do
      fetch(:puma_ports, [9000]).each do |port|
        run "cd #{current_release} && RAILS_ENV=#{fetch(:rails_env, 'staging')} bundle exec rake formaggio:puma:restart[#{puma_args(port)}]"
      end
    end
  end
end
