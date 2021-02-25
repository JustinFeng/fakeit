require 'fakeit/openapi/schema'

module OpenAPIParser
  module Schemas
    class Schema
      include Fakeit::Openapi::Schema

      alias old_type type

      def type = old_type || inferred_type

      private

      def inferred_type
        if properties
          'object'
        elsif items
          'array'
        end
      end
    end
  end
end
