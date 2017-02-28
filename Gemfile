source 'https://rubygems.org'

# Language
ruby '2.3.3'
gem 'require_all', '~> 1.4.0'

# Rack Server
gem 'puma', '~> 3.7.1'

# HTTP Framework
gem 'sinatra', '~> 2.0.0.beta2'
gem 'sinatra-contrib', '~> 2.0.0.beta2'
gem 'sinatra-cross_origin', '~> 0.4.0'
gem 'request_store', '~> 1.3.2'

# ORM
gem 'sequel', '~> 4.43.0'

# Database
gem 'pg', '~> 0.19.0'
gem 'sequel_pg', '~> 1.6.17', require: false

# Logging
gem 'semantic_logger', '~> 3.4.1'

# JSON Rendering
gem 'jbuilder', '~> 2.6.3'
gem 'yajl-ruby', '~> 1.3.0'
gem 'tilt-jbuilder', '~> 0.7.1', require: 'sinatra/jbuilder'
gem 'virtus', '~> 1.0.5'

group :development do
  gem 'countries', '~> 2.0.7'
  gem 'github_changelog_generator', '~> 1.14.3'
  gem 'gemfile_updater', '~> 0.1.0'
  gem 'nokogiri', '~> 1.7.0.1'
  gem 'rest-client', '~> 2.0.1'
  gem 'slugify', '~> 1.0.7'
  gem 'video_info', '~> 2.7'
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
