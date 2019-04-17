require 'faker'

module OpenAPIParser::Schemas
  class Schema
    BIG_INT = 2**32

    def to_example
      case type
      when 'string' then string_example
      when 'integer' then integer_example
      when 'number' then Faker::Number.decimal.to_f
      when 'boolean' then Faker::Boolean.boolean
      when 'array' then [items.to_example]
      else # object
        properties.each_with_object({}) { |(name, schema), obj| obj[name] = schema.to_example }
      end
    end

    private

    def integer_example
      if enum
        enum.to_a.sample
      else
        Faker::Number.between(minimum || 1, maximum || BIG_INT)
      end
    end

    def string_example
      if enum
        enum.to_a.sample
      elsif pattern
        Faker::Base.regexify(pattern)
      else
        Faker::Book.title
      end
    end
  end
end
