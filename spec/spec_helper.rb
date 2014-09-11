# Wear coveralls.
require 'coveralls'
Coveralls.wear!
# Include the lib directory in the load path
$: <<  "#{File.dirname(__FILE__)}/../lib"
require 'nyulibraries-formaggio'

# Mock for Rails
# Since we only need these two functions to work, it seems like
# overkill to load an entire Rails app.
module Rails
  def self.root
    "#{File.dirname(__FILE__)}/dummy"
  end

  def self.env
    "test"
  end
end
