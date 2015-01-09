Capistrano::Configuration.instance(:must_exist).load do

  after 'deploy', 'environment:mark'
  namespace :environment do
    task :mark do
      run "cd #{current_release} && echo -n '#{fetch(:stage,"")}\n' > #{fetch(:environment_marker_name,".formaggio-environment")}"
    end
  end
end
