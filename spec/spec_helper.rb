# Wear coveralls.
require 'coveralls'
Coveralls.wear!
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/autorun'