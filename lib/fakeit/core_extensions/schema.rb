module OpenAPIParser
  module Schemas
    class Schema
      BIG_INT = 2**32

      alias old_type type

      def type
        old_type || inferred_type
      end

      def to_example(use_example = false)
        return example if use_example && example

        case type
        when 'string', 'integer', 'number', 'boolean' then send("#{type}_example")
        when 'array', 'object' then send("#{type}_example", use_example)
        end
      end

      private

      def string_example
        if enum
          enum.to_a.sample
        elsif pattern
          Faker::Base.regexify(pattern)
        elsif format == 'uri'
          Faker::Internet.url
        else
          Faker::Book.title
        end
      end

      def integer_example
        if enum
          enum.to_a.sample
        else
          Faker::Number.between(minimum || 1, maximum || BIG_INT)
        end
      end

      def number_example
        Faker::Number.decimal.to_f
      end

      def boolean_example
        Faker::Boolean.boolean
      end

      def array_example(use_example)
        [items.to_example(use_example)]
      end

      def object_example(use_example)
        properties.each_with_object({}) { |(name, schema), obj| obj[name] = schema.to_example(use_example) }
      end

      def inferred_type
        if properties
          'object'
        elsif items
          'array'
        end
      end
    end
  end
end
