module Formaggio
  require 'yaml'
  require 'erb'
  require 'fileutils'
  module NewRelicManager
    # Back it up
    # Does not overwrite previous backup
    def self.backup_original
      FileUtils.cp newrelic_file, "#{newrelic_file}.bak" unless File.exists? "#{newrelic_file}.bak"
    end

    # Back it up
    def self.reset_original
      FileUtils.mv "#{newrelic_file}.bak", newrelic_file
    end

    # Rewrite the new relic file to include the rails config settings
    def self.rewrite_with_settings
      # Get the yaml before opening the file
      yaml = yaml_with_erb_parsed
      File.open(newrelic_file, "w") { |f| f.write(yaml) }
    end

    # New Relic yaml file
    def self.newrelic_file
      @newrelic_file ||= "#{root}/config/newrelic.yml"
    end

    # ERB'd YAML with ERB parsed
    def self.yaml_with_erb_parsed
      @yaml ||= YAML.load(ERB.new(File.read(newrelic_file)).result).to_yaml
    end

    # We only use New Relic for Rails at the moment
    def self.root
      raise RuntimeError.new("New Relic is only available for Rails apps at the moment") unless defined?(::Rails)
      @root ||= Rails.root
    end
  end
end
