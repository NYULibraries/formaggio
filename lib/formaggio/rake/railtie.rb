module Formaggio
  if defined?(::Rails) && ::Rails.version >= '3.1.0'
    class Railtie < Rails::Railtie
      rake_tasks do
        load "tasks/puma.rake"
        load "tasks/new_relic.rake"
      end
    end
  else
    require 'rake'
    class TaskInstaller
      include Rake::DSL if defined? Rake::DSL
      class << self
        def install_tasks
          @rake_tasks ||= []
          @rake_tasks << load("tasks/puma.rake")
          @rake_tasks << load("tasks/new_relic.rake")
          @rake_tasks
        end
      end
    end
    # Install tasks
    Formaggio::TaskInstaller.install_tasks
  end
end
