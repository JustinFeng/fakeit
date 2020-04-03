require 'json'
require 'yaml'
require 'open-uri'
require 'base64'
require 'openapi_parser'
require 'faker'
require 'rack'
require 'logger'
require 'rainbow'

Dir.glob(File.join(File.dirname(__FILE__), 'fakeit', '**/*.rb')).sort.each { require _1 }

module Fakeit
  class << self
    def build(spec_file, options)
      Rack::Builder.new do
        run App.create(spec_file, options)
      end
    end
  end
end
