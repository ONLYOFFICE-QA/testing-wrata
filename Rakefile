#!/usr/bin/env rake
# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)
require 'rspec/core/rake_task'

Runner::Application.load_tasks

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
end

task default: :spec

desc 'Task to add tag with version to repo'
task add_repo_tag: :environment do
  version = "v#{File.read('VERSION')}".strip
  `git tag -a #{version} -m "#{version}"`
  `git push --tags`
end
