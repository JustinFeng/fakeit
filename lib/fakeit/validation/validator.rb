module Fakeit
  module Validation
    class Validator
      def initialize(operation)
        @operation = operation
      end

      def validate(body:, params:)
        options = OpenAPIParser::SchemaValidator::Options.new(coerce_value: true)

        @operation.validate_request_body('application/json', JSON.parse(body)) unless body.empty?
        @operation.validate_path_params(options)
        @operation.validate_request_parameter(params, {}, options)
      rescue StandardError => e
        raise ValidationError, e.message
      end
    end
  end
end
