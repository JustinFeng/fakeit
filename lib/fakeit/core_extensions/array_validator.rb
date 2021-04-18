module OpenAPIParser
  class SchemaValidator
    class ArrayValidator
      alias old_impl coerce_and_validate

      def coerce_and_validate(value, schema, **keyword_args)
        coerced_value = schema.parent.is_a?(OpenAPIParser::Schemas::Parameter) ? [*value] : value
        old_impl(coerced_value, schema, **keyword_args)
      end
    end
  end
end
