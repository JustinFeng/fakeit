require 'fakeit/openapi/example/array_example'
require 'fakeit/openapi/example/boolean_example'
require 'fakeit/openapi/example/integer_example'
require 'fakeit/openapi/example/number_example'
require 'fakeit/openapi/example/object_example'
require 'fakeit/openapi/example/string_example'

module Fakeit
  module Openapi
    module Schema
      include Fakeit::Openapi::Example

      def to_example(use_example = false)
        return example if use_example && example

        return one_of_example(use_example) if one_of
        return all_of_example(use_example) if all_of
        return any_of_example(use_example) if any_of

        type_based_example(use_example)
      end

      private

      def one_of_example(use_example)
        one_of.sample.to_example(use_example)
      end

      def all_of_example(use_example)
        all_of
          .select { |option| option.type == 'object' }
          .map { |option| option.to_example(use_example) }
          .reduce(&:merge)
      end

      def any_of_example(use_example)
        any_of
          .select { |option| option.type == 'object' }
          .sample(Faker::Number.between(1, any_of.size))
          .map { |option| option.to_example(use_example) }
          .reduce(&:merge)
      end

      def type_based_example(use_example)
        case type
        when 'string', 'integer', 'number', 'boolean' then send("#{type}_example")
        when 'array', 'object' then send("#{type}_example", use_example)
        end
      end
    end
  end
end
