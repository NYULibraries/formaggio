require 'bundler'

Capistrano::Configuration.instance(:must_exist).load do
  before 'deploy:finalize_update', 'deploy:assets:symlink'

  namespace :deploy do
    namespace :assets do
      def changed_gem_assets gem_name
        gem_revision = capture("cd #{fetch :latest_release} && awk '/#{gem_name}/{getline; print}' Gemfile.lock").to_s.strip!
        capture("cd #{fetch :latest_release} && git diff #{fetch :previous_revision} | grep '#{gem_revision}' | wc -l").to_i
      end

      desc "Precompiles if assets have been changed"
      task :precompile, :roles => :web, :max_hosts => 1, :except => { :no_release => true } do
        force_compile = fetch(:force_precompile, false)
        changed_asset_count = 0
        rails_env = "RAILS_ENV=#{fetch(:rails_env, fetch(:stage, fetch(:default_stage, 'staging')))}"
        rails_group = "RAILS_GROUP=assets"
        begin
          from = source.next_revision(current_revision)
          asset_locations = 'app/assets/ lib/assets vendor/assets'
          scm_log = (fetch(:scm, "") == :git) ? "git log #{from}" : source.local.log(from)
          changed_asset_count = capture("cd #{fetch :latest_release} && #{scm_log} #{asset_locations} | wc -l").to_i
          fetch(:assets_gem, []).each do |gem_name|
            changed_asset_count += changed_gem_assets gem_name
          end
        rescue Exception => e
          logger.info "Error: #{e}, forcing precompile"
          force_compile = true
        end
        if (changed_asset_count > 0 || force_compile) && !fetch(:ignore_precompile, false)
          logger.info "#{changed_asset_count} assets have changed. Pre-compiling"
          run_locally ("bundle exec rake assets:clean #{rails_env}")
          run_locally ("bundle exec rake assets:precompile #{rails_env}")
          run_locally "cd public && tar -jcf assets.tar.bz2 assets"
          run "cd #{shared_path} && mv assets/manifest* #{previous_release}/assets_manifest.json || true"
          run "cd #{shared_path} && rm -rf assets && mkdir assets"
          top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
          run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
          run_locally "rm public/assets.tar.bz2"
          run_locally("bundle exec rake assets:clean #{rails_env}")
        else
          logger.info "#{changed_asset_count} assets have changed. Skipping asset pre-compilation"
        end
      end

      desc "Creates a symlink for assets"
      task :symlink, roles: :web do
        run ("rm -rf #{fetch :current_release}/public/assets &&
              mkdir -p #{fetch :current_release}/public &&
              mkdir -p #{fetch :shared_path}/assets &&
              ln -s #{fetch :shared_path}/assets #{fetch :current_release}/public/assets")
      end
    end
  end
end
