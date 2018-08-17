# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/yarn'
require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/bundler'
require "capistrano/checks"
require 'capistrano/rails/migrations'
require 'capistrano/rails/assets'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

#require 'capistrano/honeybadger'
