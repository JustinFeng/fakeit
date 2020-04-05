require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/lib/fakeit/core_extensions'
  enable_coverage :branch
end
SimpleCov.minimum_coverage line: 100, branch: 100

require 'bundler/setup'
require 'fakeit'
require 'rack/test'

module Helpers
  def load_schema(name)
    File
      .read("spec/fixtures/#{name}.json")
      .then(&JSON.method(:parse))
      .then(&OpenAPIParser.method(:parse))
      .request_operation(:get, '/')
      .operation_object
      .responses
      .response['200']
      .content['application/json']
      .schema
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    allow(Fakeit::Logger).to receive(:warn)
  end

  config.include Helpers
end
