# frozen_string_literal: true

source 'https://rubygems.org'

ruby '>= 3.4.0'

gem 'bootstrap'
gem 'devise'
gem 'exception_notification'
gem 'font-awesome-rails'
gem 'jbuilder'
gem 'listen'
gem 'net-ping'
gem 'onlyoffice_digitalocean_wrapper'
gem 'onlyoffice_github_helper'
gem 'onlyoffice_rspec_result_parser'
gem 'pg'
gem 'process_exists'
gem 'puma'
gem 'rails', '7.2.2.1'
gem 'rubyzip'
gem 'sassc-rails'
gem 'sprockets-rails'
gem 'terser'
gem 'webpacker'

# Without this gem in development - not all rake rspec tasks are loaded
# See details https://github.com/rspec/rspec-rails#installation
# And in test it should be because it's required in tests
gem 'rspec-rails', groups: %i[development test]

group :development do
  gem 'overcommit'
  gem 'rubocop'
  gem 'rubocop-capybara', '~> 2'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails', '~> 2'
  gem 'scss_lint', require: false
end

group :test do
  gem 'capybara'
  gem 'rspec'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
end
