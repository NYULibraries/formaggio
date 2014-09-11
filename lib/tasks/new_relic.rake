namespace :nyulibraries do
  namespace :deploy do
    namespace :newrelic do
      desc "Set the New Relic file with ERB parsed"
      task :set => :backup  do |task|
        # Load up the Rails environment
        Rake::Task[:environment].invoke
        Nyulibraries::Formaggio::NewRelicManager.rewrite_with_settings
      end

      desc "Backup the New Relic file"
      task :backup do |task|
        Nyulibraries::Formaggio::NewRelicManager.backup_original
      end

      desc "Reset the New Relic file"
      task :reset do |task|
        Nyulibraries::Formaggio::NewRelicManager.reset_original
      end
    end
  end
end
