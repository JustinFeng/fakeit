require 'fakeit/openapi/example/array_example'
require 'fakeit/openapi/example/boolean_example'
require 'fakeit/openapi/example/integer_example'
require 'fakeit/openapi/example/number_example'
require 'fakeit/openapi/example/object_example'
require 'fakeit/openapi/example/string_example'

module Fakeit
  module Openapi
    module Schema
      include Fakeit::Openapi::Example

      def to_example(use_example = false)
        return example if use_example && example

        case type
        when 'string', 'integer', 'number', 'boolean' then send("#{type}_example")
        when 'array', 'object' then send("#{type}_example", use_example)
        end
      end
    end
  end
end
