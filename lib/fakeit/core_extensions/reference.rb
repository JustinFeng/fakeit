require 'fakeit/openapi/schema'

module OpenAPIParser
  module Schemas
    class Reference
      def to_example(_)
        raise Fakeit::Openapi::ReferenceError, "Invalid $ref at \"#{ref}\""
      end
    end
  end
end
