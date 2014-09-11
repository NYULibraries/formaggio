namespace :nyulibraries do
  namespace :deploy do
    namespace :puma do
      desc "Start the puma web server on the given port"
      task :start, [:port] => :write_scripts do |task, args|
        Nyulibraries::Formaggio::PumaManager.start(args[:port])
      end

      desc "Retart the puma web server on the given port"
      task :restart, [:port] => :write_scripts do |task, args|
        Nyulibraries::Formaggio::PumaManager.restart(args[:port])
      end

      desc "Stop the puma web server on the given port"
      task :stop, :port do |task, args|
        Nyulibraries::Formaggio::PumaManager.stop(args[:port])
      end

      desc "Write the start and restart scripts to files. Does not overwrite if the files exist"
      task :write_scripts, :port do |task, args|
        Nyulibraries::Formaggio::PumaManager.write_scripts(args[:port])
      end
    end
  end
end
