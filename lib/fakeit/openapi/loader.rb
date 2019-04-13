require 'open-uri'
require 'json'
require 'yaml'
require 'openapi_parser'
require 'fakeit/openapi/specification'

module Fakeit::Openapi
  class << self
    def load(src)
      parse_method = parse_method(src)
      content = open(src, &:read)
      doc = OpenAPIParser.parse(parse_method.call(content))

      Specification.new(doc)
    end

    private

    def parse_method(src)
      case File.extname(src)
      when '.json' then JSON.method(:parse)
      when '.yml' then YAML.method(:safe_load)
      else raise 'Invalid openapi specification file'
      end
    end
  end
end
