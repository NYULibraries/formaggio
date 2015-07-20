namespace :formaggio do
  namespace :puma do
    desc "Start the puma web server on the given port"
    task :start, [:port] => :write_scripts do |task, args|
      if args.extras.first == 'ssl'
        ssl_enabled = true
      else
        ssl_enabled = false
      end
      Formaggio::PumaManager.start(args[:port], ssl_enabled: ssl_enabled)
    end

    desc "Retart the puma web server on the given port"
    task :restart, [:port] => :write_scripts do |task, args|
      if args.extras.first == 'ssl'
        ssl_enabled = true
      else
        ssl_enabled = false
      end
      Formaggio::PumaManager.restart(args[:port], ssl_enabled: ssl_enabled)
    end

    desc "Stop the puma web server on the given port"
    task :stop, :port do |task, args|
      if args.extras.first == 'ssl'
        ssl_enabled = true
      else
        ssl_enabled = false
      end
      Formaggio::PumaManager.stop(args[:port], ssl_enabled: ssl_enabled)
    end

    desc "Write the start and restart scripts to files. Does not overwrite if the files exist"
    task :write_scripts, :port do |task, args|
      if args.extras.first == 'ssl'
        ssl_enabled = true
      else
        ssl_enabled = false
      end
      Formaggio::PumaManager.write_scripts(args[:port], ssl_enabled: ssl_enabled)
    end
  end
end
