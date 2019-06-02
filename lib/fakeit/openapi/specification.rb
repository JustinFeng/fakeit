module Fakeit
  module Openapi
    class Specification
      def initialize(doc)
        @doc = doc
      end

      def operation(method, path, options)
        @doc
          .request_operation(method, path)
          &.then { |operation| Operation.new(operation, options) }
      end
    end
  end
end
