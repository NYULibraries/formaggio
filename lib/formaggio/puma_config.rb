module Formaggio
  class PumaConfig
    attr_reader :port, :root, :env, :ssl_enabled, :host_ip,
                :keystore, :keystore_pass, :threads

    def initialize(port, opts = {})
      @port = port
      # If we're using Rails, use the Rails root, otherwise use the arg
      if defined?(::Rails)
        @root = Rails.root
        @env  = Rails.env
      else
        @root = opts.fetch(:root, nil)
        raise RuntimeError.new("You need to tell me the root of your Puma app") if @root.nil?
        @env = opts.fetch(:env, nil)
        raise RuntimeError.new("You need to tell me the environment of your Puma app") if @env.nil?
      end
      @ssl_enabled    = opts.fetch(:ssl_enabled,    false)
      @host_ip        = opts.fetch(:host_ip,        '127.0.0.1')
      @keystore       = opts.fetch(:keystore,       ENV['KEYSTORE'])
      @keystore_pass  = opts.fetch(:keystore_pass,  ENV['KEYSTORE_PASS'])
      @threads        = opts.fetch(:threads,        '2:4')
    end

    def scripts_path
      @scripts_path ||= "#{root}/config/deploy/puma"
    end

    def pid
      @pid ||= "#{root}/tmp/pids/puma-#{port}.pid"
    end

    def log
      @log ||= "#{root}/log/puma-#{env}-#{port}.log"
    end

    def ssl_params
      "?keystore=#{keystore}&keystore-pass=#{keystore_pass}&verify_mode=none"
    end

    def ssl_uri
      "'ssl://#{host_ip}:#{port}#{ssl_params}'"
    end

    def tcp_uri
      "'tcp://#{host_ip}:#{port}'"
    end

    def bind
      @bind ||= (ssl_enabled) ? ssl_uri : tcp_uri
    end

    def start_file
      @start_file ||= "#{scripts_path}/start-#{port}.sh"
    end

    def restart_file
      @restart_file ||= "#{scripts_path}/restart-#{port}.sh"
    end

    # Start command
    def start_cmd
      @start_cmd ||= "cd #{root} && RAILS_ENV=#{env} bundle exec #{start_file} && echo 'Starting' >> #{log}"
    end

    # Stop command
    def stop_cmd
      @stop_cmd ||= "kill -9 `cat #{pid}` && rm -rf #{pid} && echo 'Stopping..' >> #{log}"
    end

    # Restart command
    def restart_cmd
      @restart_cmd ||= "cd #{root} && RAILS_ENV=#{env} bundle exec #{restart_file}"
    end

    # Start script code
    def start_script
      @start_script ||= %Q(
        #!/bin/bash
        puma -b #{bind} -e #{env} -t #{threads} --pidfile #{pid} >> #{log} 2>&1 &
        exit
      ).strip
    end

    # Restart script code
    def restart_script
      @restart_script ||= %Q(
        #!/bin/bash
        if [ -a #{pid} ]; then
          #{stop_cmd}
        fi
        #{start_cmd}
        exit
      ).strip
    end
  end
end
