require "base64"
require "faker"
require "json"
require "logger"
require "openapi_parser"
require "open-uri"
require "rack"
require "rackup"
require "rainbow"
require "regexp-examples"
require "webrick"
require "yaml"

Dir.glob(File.join(File.dirname(__FILE__), "fakeit", "**/*.rb")).each { require it }

module Fakeit
  class << self
    def build(spec_file, options)
      Rack::Builder.new do
        run App::AppBuilder.new(spec_file, options).build
      end
    end
  end
end
