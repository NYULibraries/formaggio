# Multistage
require 'capistrano/ext/multistage'

Capistrano::Configuration.instance(:must_exist).load do
  after 'multistage:ensure', 'config:see'
end