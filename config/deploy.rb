# Lock to Capistrano version
lock "~> 3.8"

@application = "exercism"

set :application, @application
set :repo_url, "git@github.com:exercism/prototype.git"
set :branch, 'master'

set :linked_files, %w{config/database.yml config/secrets.yml config/smtp.yml}
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :deploy_to, "/opt/#{@application}"

set :default_env, {
  'DEVISE_TOKEN_AUTH_SECRET_KEY' => "DUMMY"
}

set :pty, true
