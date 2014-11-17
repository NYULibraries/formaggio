[![Build Status](https://travis-ci.org/NYULibraries/formaggio.png?branch=master)](https://travis-ci.org/NYULibraries/formaggio)
[![Dependency Status](https://gemnasium.com/NYULibraries/formaggio.png)](https://gemnasium.com/NYULibraries/formaggio)
[![Code Climate](https://codeclimate.com/github/NYULibraries/formaggio.png)](https://codeclimate.com/github/NYULibraries/formaggio)
[![Coverage Status](https://coveralls.io/repos/NYULibraries/formaggio/badge.png)](https://coveralls.io/r/NYULibraries/formaggio)

# Formaggio

Formaggio works with Capistrano, Rake, and Figs to offer a common deploy schema for NYULibraries apps. Bundled with Formaggio are a set of common rake tasks for the NYU libraries, as well as a set of common Capistrano recipes mixed into a delicious default recipe. Capistrano recipes end up handling most of the Rake tasks, but they can be used independently. Using Figs give us the added benefit of being Railsless!

# Gemfile

```
gem "formaggio", github: "NYULibraries/formaggio"
```

# Rake Tasks

## New Relic
Since the NYU Libraries uses the ERB in YAML files,
we need a task to explicitly load the relevant settings (e.g. license key, app name) to newrelic.yml in the absence
of a Rails environment. This is mostly for backwards compatibility, as going forward, we'll always be using Figs :bowtie:.

    rake formaggio:newrelic:set
    rake formaggio:newrelic:reset

## Puma
Start, stop, and restart tasks for the [Puma webserver](http://puma.io/).

    rake formaggio:puma:start[9292]
    rake formaggio:puma:restart[9292]
    rake formaggio:puma:stop[9292]

# Capistrano Recipes

## Assets

This provides recipes that allow us to precompile the assets (only if their were changes!) and to create a
symlink for the assets.

    # In your config/deploy.rb
    require 'formaggio/capistrano/assets'

Easy, the asset precompilation will work automatically after the capistrano's `deploy:update_code` task, and the
symlinking will work automatically before capistrano's `finalize_update`.

If you need, you can always run `cap deploy:assets:precompile` or `cap deploy:assets:symlink` in a CLI.

## Bundler

All this does is that it loads up
[Bundler's capistrano recipe](https://github.com/bundler/bundler/blob/master/lib/bundler/capistrano.rb)
and hooks [`deploy:migrate`](https://github.com/capistrano/capistrano/blob/1fd63128120115657acec102fec573ca9d9e88e8/lib/capistrano/recipes/deploy.rb#L426)
to run after it.

    # In your config/deploy.rb
    require 'formaggio/capistrano/bundler'

## Cache

Clears rail cache!

    # In your config/deploy.rb
    require 'formaggio/capistrano/cache'

Or you can run `cap cache:tmp_clear`.

## Multistage

Loads up capistrano's [multistage](https://github.com/capistrano/capistrano/blob/master/lib/capistrano/ext/multistage.rb).
Thats it.

    # In your config/deploy.rb
    require 'formaggio/capistrano/multistage'
    # Same as
    require 'capistrano/ext/multistage

## New Relic

Loads up [New Relic's capistrano recipes](https://github.com/newrelic/rpm/blob/master/lib/new_relic/recipes.rb)
and adds two new tasks, `newrelic:set` and `newrelic:reset`.

`cap newrelic:set` just runs the [rake task defined above](#new-relic),
and `cap newrelic:set` runs the reset one. Also hooks New Relic's `newrelic:notice_deployment` to run after
`deploy:update`.

    # In your config/deploy.rb
    require 'formaggio/capistrano/new_relic'

## Rails Config

This beast makes use of the [`rails_config`](/railsjedi/rails_config) gem and loads the relevant settings
(app name, servers, etc) from capistrano.yml.

`rails_config:set_variables` reads from capistrano.yml and sets variables and `rails_config:set_servers` sets
the servers that multistage will use to deploy to but you'll only need to worry about `rails_config:see` which
prints out the results of the first two `rails_config` tasks.

This one is very important for NYULibraries!

    # In your config/deploy.rb
    require 'formaggio/capistrano/rails_config'

## RVM

Loads up [rvm's capistrano](https://github.com/wayneeseguin/rvm/blob/master/lib/rvm/capistrano.rb) and hooks
it on to run before `deploy`.

    # In your config/deploy.rb
    require 'formaggio/capistrano/rvm'

## Send Diff

Very new idea, trys to find the difference from the last two git tags and sends the difference to a specified
recipient. Run using `cap send_diff:send_diff`.

    # In your config/deploy.rb
    require 'formaggio/capistrano/send_diff'

## Tagging

Tags the deployed app with a prespecified tagging convention.
`cap tagging:checkout_branch` will specify the branch to tag and check it out.
`cap tagging:deploy` will create the tag and deploy it.

    # In your config/deploy.rb
    require 'formaggio/capistrano/tagging'

## Server

Since this could work on an app that requires a server, we have some server specific capistrano tasks.

### Passenger

Capistrano recipes to control passenger.

  * `cap deploy:start` - Start passenger server.
  * `cap deploy:stop` - Stop passenger server.
  * `cap deploy:restart` - Restart passenger server.
  * `cap deploy:passenger_symlink` - Links passenger to the latest app location.


    # In your config/deploy.rb
    require 'formaggio/capistrano/server/passenger'


### Puma

Capistrano recipes to control puma. Uses this very gem's [rake tasks](#puma)

  * `cap deploy:start` - Start puma server.
  * `cap deploy:stop` - Stop puma server.
  * `cap deploy:restart` - Restart puma server.


    # In your config/deploy.rb
    require 'formaggio/capistrano/server/puma'

# Defaults

We've taken the liberty to define a default recipe and default settings. Most of our apps won't need anything
past defaults, but if there are small changes you can easily override them.

    # In your config/deploy.rb
    require 'formaggio/capistrano'

This will load the [default attributes](https://github.com/NYULibraries/formaggio/blob/master/lib/formaggio/capistrano/default_attributes.rb),
with a [default recipe](https://github.com/NYULibraries/formaggio/blob/master/lib/formaggio/capistrano/default_recipes.rb)
that will use all of the above mentioned capistrano
recipes with a passenger server. All you have to do is

    # In your config/deploy.rb
    require 'formaggio/capistrano'
    set :app_title, "APP_TITLE"

If your app's title is different from the git repo, then you have to also do

    # In your config/deploy.rb
    require 'formaggio/capistrano'
    set :app_title, "APP_TITLE"
    set :repository, "git@github.com:GITUSER/REPO_NAME.git"

Optionally, you can define who to send the git diff info to by:

    # In your config/deploy.rb
    require 'formaggio/capistrano'
    set :app_title, "APP_TITLE"
    set :repository, "git@github.com:GITUSER/REPO_NAME.git"
    set :recipient, "email" # Has to be email address!

Finally, you can override any one of the defaults, for example overriding branch:

    # In your config/deploy.rb
    require 'formaggio/capistrano'
    set :app_title, "APP_TITLE"
    set :repository, "git@github.com:GITUSER/REPO_NAME.git"
    set :recipient, "email" # Has to be email address!
    set :branch, "cool_branch_doritos"
