require 'json'
require 'yaml'
require 'open-uri'
require 'openapi_parser'
require 'faker'
require 'rack'

require 'fakeit/app/app'
require 'fakeit/core_extensions/schema'
require 'fakeit/openapi/loader'
require 'fakeit/openapi/operation'
require 'fakeit/openapi/specification'

module Fakeit
  class << self
    def build(spec_file)
      Rack::Builder.new do
        run App.create(spec_file)
      end
    end
  end
end
