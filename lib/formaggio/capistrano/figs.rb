# Figs
require 'figs'

Capistrano::Configuration.instance(:must_exist).load do
  namespace :figs do
    task :load_ do
      if File.exists?("Figsfile")
        Figs.load(stage: fetch(:rails_env, fetch(:default_stage)))
      end
    end
  end
end