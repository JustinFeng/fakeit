require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end
SimpleCov.minimum_coverage 100

require 'bundler/setup'
require 'fakeit'
require 'rack/test'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(Fakeit::Logger).to receive(:warn)
  end
end
