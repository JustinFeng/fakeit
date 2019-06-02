require 'json'
require 'yaml'
require 'open-uri'
require 'openapi_parser'
require 'faker'
require 'rack'
require 'logger'

Dir.glob(File.join(File.dirname(__FILE__), 'fakeit', '/**/*.rb')).each { |file| require file }

module Fakeit
  class << self
    def build(spec_file)
      Rack::Builder.new do
        run App.create(spec_file)
      end
    end
  end
end
