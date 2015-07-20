module Formaggio
  module PumaManager

    def self.puma_config(*args)
      PumaConfig.new(*args)
    end

    # Start the puma web server on the given port
    def self.start(port, opts)
      config = puma_config(port)
      exec config.start_cmd
    end

    # Restart the puma web server on the given port
    def self.restart(port, opts)
      config = puma_config(port)
      exec config.restart_cmd
    end

    # Stop the puma web server on the given port
    def self.stop(port, opts)
      config = puma_config(port)
      exec config.stop_cmd
    end

    # Write the start and restart scripts to files
    # Does not overwrite if the files exist
    def self.write_scripts(port, opts)
      config = puma_config(port, opts)
      make_scripts_dir(config)
      write_start_script(config)
      write_restart_script(config)
    end

    # Write the start script to a file
    # Does not overwrite if the file exists
    def self.write_start_script(config)
      write_script_to_file(config.start_script, config.start_file)
    end

    # Write the restart script to a file
    # Does not overwrite if the file exists
    def self.write_restart_script(config)
      write_script_to_file(config.restart_script, config.restart_file)
    end

    # Write the given script to the given file and make executable
    # Does not overwrite if the file exists
    def self.write_script_to_file(script, file)
      # Put the start script code in a file
      File.open(file, "w") { |f| f.write(script) } unless File.exists? file
      # Make the file executable
      FileUtils.chmod "a+x", file unless File.executable? file
    end

    # Create the scripts directory if necessary
    def self.make_scripts_dir(config)
      FileUtils.mkdir_p config.scripts_path unless Dir.exists? config.scripts_path
    end
  end
end
