module Fakeit
  module Openapi
    module Example
      def integer_example(example_options)
        if example_options[:use_static][type: 'integer', property: example_options[:property]]
          static_integer_example
        else
          random_integer_example
        end
      end

      private

      def static_integer_example
        if enum
          enum.to_a.first
        else
          int_rand_end * int_multiple
        end
      end

      def random_integer_example
        if enum
          enum.to_a.sample
        else
          Faker::Number.between(from: int_rand_begin, to: int_rand_end) * int_multiple
        end
      end

      def int_rand_begin
        min_int / int_multiple + int_rand_begin_adjust
      end

      def int_rand_end
        max_int / int_multiple
      end

      def int_rand_begin_adjust
        (min_int % int_multiple).zero? ? 0 : 1
      end

      def int_multiple
        multipleOf || 1
      end

      def min_int
        if minimum
          exclusiveMinimum ? minimum + 1 : minimum
        else
          -2**(int_bits - 1)
        end
      end

      def max_int
        if maximum
          exclusiveMaximum ? maximum - 1 : maximum
        else
          2**(int_bits - 1) - 1
        end
      end

      def int_bits
        (format || 'int32')[/\d+/].to_i
      end
    end
  end
end
