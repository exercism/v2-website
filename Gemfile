source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 6.0.0'
gem 'puma', '~> 3.7'
gem 'mysql2'

gem 'dalli'
gem 'devise', ">= 4.7.1"
gem 'omniauth-github'
gem 'kaminari'
gem 'friendly_id', github: 'norman/friendly_id', branch: 'master', ref: 'cdd5971f91c40e0c05e5afb498d2ec1b452ffb44'
gem 'mandate'

gem 'haml-rails'
gem 'jquery-rails'
gem 'sassc-rails'
gem 'uglifier', '>= 1.3.0'
gem 'premailer-rails'

gem 'commonmarker', require: false
gem 'rugged'
gem 'loofah'
gem 'lmdb'
gem 'octokit'
gem "bugsnag"
gem 'image_processing', '~> 1.2'
gem 'rest-client'
gem 'rubyzip', require: false

gem 'propono'
gem 'aws-sdk-s3'

gem 'delayed_job_active_record'
gem 'daemons'

gem 'bootsnap', '>= 1.1.0', require: false

gem 'lograge'

gem 'recaptcha'

gem 'flipper'
gem 'flipper-active_record'
gem 'flipper-ui'

gem 'twitter', require: false

gem 'webpacker', '~> 4.0'

group :production do
  gem "skylight"
end

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.0'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'bullet'
  gem 'rubocop', require: false
  gem 'haml-lint', require: false
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', '~> 3.6'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rvm'
  gem 'capistrano-yarn'
  gem 'letter_opener'
end

group :test do
  gem 'simplecov', require: false
  gem 'minitest', '~> 5.10', '!= 5.10.2'
  gem 'minitest-stub-const'
  gem 'mocha'
  gem 'rails-controller-testing'
  gem 'timecop'
  gem 'chromedriver-helper'
  gem 'webmock'
end

group :development, :production do
  gem 'capistrano-checks'
end
