require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

task default: %i[spec rubocop]

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new
