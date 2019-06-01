module Fakeit
  module Openapi
    class Operation
      def initialize(request_operation)
        @request_operation = request_operation
        @validator = Fakeit::Validation::Validator.new(request_operation)
      end

      def status
        response.first.to_i
      end

      def headers
        response_headers
          &.map { |k, v| [k, v.schema.to_example] }
          &.tap { |headers| headers.push(['Content-Type', response_content_type]) if response_content_type }
          .to_h
      end

      def body
        response_schema&.schema&.to_example&.then(&JSON.method(:generate)).to_s
      end

      def validate(**request_parts)
        @validator.validate(request_parts)
      end

      private

      def response_content
        response.last.content&.find { |k, _| k =~ %r{^application/.*json} }
      end

      def response_schema
        response_content&.last
      end

      def response_content_type
        response_content&.first
      end

      def response_headers
        response.last.headers
      end

      def response
        @request_operation.operation_object.responses.response.min
      end
    end
  end
end
