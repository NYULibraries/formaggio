namespace :formaggio do
  namespace :puma do
    def puma_hash(args)
      @puma_hash ||= {
        ssl_enabled: args.extras.include?('ssl'),
        threads: args.extras.detect{|element| element.match(/^\d+:\d+$/) }
      }
    end

    desc "Start the puma web server on the given port"
    task :start, [:port] => :write_scripts do |task, args|
      Formaggio::PumaManager.start(args[:port], puma_hash(args))
    end

    desc "Retart the puma web server on the given port"
    task :restart, [:port] => :write_scripts do |task, args|
      Formaggio::PumaManager.restart(args[:port], puma_hash(args))
    end

    desc "Stop the puma web server on the given port"
    task :stop, :port do |task, args|
      Formaggio::PumaManager.stop(args[:port], puma_hash(args))
    end

    desc "Write the start and restart scripts to files. Does not overwrite if the files exist"
    task :write_scripts, :port do |task, args|
      Formaggio::PumaManager.write_scripts(args[:port], puma_hash(args))
    end
  end
end
