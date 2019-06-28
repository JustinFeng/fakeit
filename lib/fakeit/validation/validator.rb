module Fakeit
  module Validation
    class Validator
      def initialize(operation)
        @operation = operation
      end

      def validate(body: '', params: {}, headers: {})
        options = OpenAPIParser::SchemaValidator::Options.new(coerce_value: true)

        if request_content_type
          body_data = parse(body)
          @operation.validate_request_body(request_content_type, body_data)
        end
        @operation.validate_path_params(options)
        @operation.validate_request_parameter(params, headers, options)
      rescue StandardError => e
        raise ValidationError, e.message
      end

      private

      def parse(body)
        JSON.parse(body)
      rescue StandardError
        raise ValidationError, 'Invalid json payload'
      end

      def request_content_type
        request_body&.content&.find { |k, _| k =~ %r{^application/.*json} }&.first
      end

      def request_body
        @operation.operation_object.request_body
      end
    end
  end
end
