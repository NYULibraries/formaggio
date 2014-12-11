Capistrano::Configuration.instance(:must_exist).load do
  after "deploy:restart", "deploy:cleanup"
  before "deploy:cleanup", "touch:latest_release"
  namespace :touch do
    task :set_variables do
      run "touch #{current_release}"
    end
  end
end
