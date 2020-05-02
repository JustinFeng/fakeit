module Fakeit
  module Validation
    class Validator
      def initialize(operation)
        @operation = operation
      end

      def validate(body: {}, params: {}, headers: {})
        options = OpenAPIParser::SchemaValidator::Options.new(coerce_value: true)

        validate_body(body) unless request_content_types.empty?
        @operation.validate_path_params(options)
        @operation.validate_request_parameter(params, headers, options)
      rescue StandardError => e
        raise ValidationError, e.message
      end

      private

      def validate_body(body)
        if request_content_types.include?(body[:media_type])
          @operation.validate_request_body(body[:media_type], body[:data]) if can_validate?(body[:media_type])
        else
          raise ValidationError, 'Invalid request content type' if body[:media_type]
          raise ValidationError, 'Request body is required' if request_body.required
        end
      end

      def can_validate?(media_type)
        media_type =~ %r{^application/.*json} || media_type == 'multipart/form-data'
      end

      def request_content_types
        request_body&.content&.keys.to_a
      end

      def request_body
        @operation.operation_object.request_body
      end
    end
  end
end
