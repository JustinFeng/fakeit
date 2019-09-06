module Fakeit
  module Openapi
    class Specification
      def initialize(spec_file)
        @spec_file = spec_file
        @doc = Fakeit::Openapi.load(spec_file)
      end

      def operation(method, path, options)
        @doc
          .request_operation(method, path)
          &.then { |operation| Operation.new(operation, options) }
      end
    end
  end
end
