module Fakeit
  module Openapi
    class Operation
      def initialize(request_operation, options)
        @request_operation = request_operation
        @validator = Fakeit::Validation::Validator.new(request_operation)
        @options = options
      end

      def status
        response.first.to_i
      end

      def headers
        response_headers
          &.map { |k, v| [k, v.schema.to_example(@options.use_example)] }
          .to_h
          .tap { |headers| headers['Content-Type'] = response_content_type if response_content_type }
      end

      def body
        response_schema
          &.schema
          &.to_example(@options.use_example)
          &.then(&JSON.method(:generate))
          .to_s
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
