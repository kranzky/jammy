source 'https://rubygems.org'
ruby '2.4.0'

# Language
ruby '2.4.0'
gem 'require_all', '~> 1.4.0'

# Rack Server
gem 'puma', '~> 3.6.2'

# HTTP Framework
gem 'sinatra', '~> 2.0.0.beta2'
gem 'sinatra-contrib', '~> 2.0.0.beta2'
gem 'request_store', '~> 1.3.2'

# ORM
gem 'sequel', '~> 4.42.1'

# Database
gem 'pg', '~> 0.19.0'
gem 'sequel_pg', '~> 1.6.17', require: false

# Logging
gem 'semantic_logger', '~> 3.4.1'

# JSON Rendering
gem 'jbuilder', '~> 2.6.1'
gem 'yajl-ruby', '~> 1.3.0'
gem 'tilt-jbuilder', '~> 0.7.1', require: 'sinatra/jbuilder'

group :development do
  gem 'github_changelog_generator', '~> 1.14.3'
  gem 'gemfile_updater', '~> 0.1.0'
  gem 'nokogiri', '~> 1.7.0.1'
  gem 'rest-client', '~> 2.0.0'
end

group :test do
  gem 'rspec', '~> 3.5.0'
end

group :development, :test do
  gem 'awesome_print', '~> 1.7.0'
  gem 'byebug', '~> 9.0.6'
end

group :production do
end
