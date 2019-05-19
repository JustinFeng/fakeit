module Fakeit
  module Openapi
    class Operation
      def initialize(request_operation)
        @request_operation = request_operation
        @validator = Fakeit::Validation::Validator.new(request_operation)
      end

      def status
        openapi_response.first.to_i
      end

      def headers
        openapi_headers&.map { |k, v| [k, v.schema.to_example] }.to_h
      end

      def body
        openapi_content&.schema&.to_example&.then(&JSON.method(:generate)).to_s
      end

      def validate(**request_parts)
        @validator.validate(request_parts)
      end

      private

      def openapi_content
        openapi_response.last.content&.find { |k, _| k =~ %r{^application/.*json} }&.last
      end

      def openapi_headers
        openapi_response.last.headers
      end

      def openapi_response
        @request_operation.operation_object.responses.response.min
      end
    end
  end
end
