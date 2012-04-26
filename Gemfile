source 'http://rubygems.org'

gem 'rails', '3.2.3'
gem 'delayed_job'
gem 'jquery-rails'
gem 'json'
gem 'octokit'
gem 'domainatrix'
gem 'will_paginate'
gem 'right_aws'
gem 'meta_search'

group :production do
  gem 'pg'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.2.5"
  gem 'coffee-rails', "~> 3.2.2"
  gem 'uglifier'
end


group :development do
  gem 'ZenTest'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'mocha'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'yard'
  gem 'spork', '~> 0.9.0.rc'
  gem 'faker'
  gem 'sqlite3'
end

group :test do
  gem 'webmock'
end
