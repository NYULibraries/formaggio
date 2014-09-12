Capistrano::Configuration.instance(:must_exist).load do
  # Hack on Capistrano, Capistrnao requires :repository to be set, and thus is always set with garbage value.
  # This makes it impossible to detect wether or not the user set it, so unsetting here solves that.
  # Also, we re-set it here anyway, so it's safe thus far...
  unset :repository
  unset :application
  
  # SSH options
  _cset :ssh_options, {:forward_agent => true}
  
  # Git vars
  _cset :scm, :git
  _cset :deploy_via, :remote_cache
  _cset :branch, 'development'
  _cset :git_enable_submodules, 1
  
  # Environments
  _cset :stages, ["staging", "production"]
  _cset :default_stage, "staging"
  _cset(:keep_releases) {fetch(:stage,"").eql?("production") ? 5 : 1}
  _cset :use_sudo, false
  
  # Application specs
  _cset(:application) {"#{fetch :app_title}_repos"}
  _cset(:repository) {"git@github.com:NYULibraries/#{fetch :app_title}.git"}
  
  # Git Tagging vars
  _cset(:current_tag) {"#{fetch :stage}_#{fetch(:releases).last}"}
  _cset(:previous_tag) {"#{fetch :stage}_#{fetch(:releases)[-2]}"}
  _cset :tagging_remote, 'origin'
  _cset :tagging_environments, ["production"]
  
  # RVM  vars
  _cset :rvm_ruby_string, "ruby-1.9.3-p448"
  _cset :rvm_type, :user
  
  # Rails specific vars
  _cset :normalize_asset_timestamps, false
  
  # New Relic vars
  _cset :new_relic_environments, ["production"]
  
  # Bundler vars
  _cset :bundle_without, [:development, :test]
  _cset :bundle_cleaning_environments, ["staging", "development"]
  
  # Precompile vars
  _cset :assets_gem, ["nyulibraries-assets.git", "nyulibraries_assets.git"]
  _cset :force_precompile, false
  _cset :ignore_precompile, false

end
