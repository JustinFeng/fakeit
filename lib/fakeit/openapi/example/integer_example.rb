module Fakeit
  module Openapi
    module Example
      BIG_INT = 2**32

      def integer_example
        if enum
          enum.to_a.sample
        else
          Faker::Number.between(rand_begin, rand_end) * multiple
        end
      end

      private

      def rand_begin
        min_int / multiple + rand_begin_adjust
      end

      def rand_end
        max_int / multiple
      end

      def rand_begin_adjust
        (min_int % multiple).zero? ? 0 : 1
      end

      def multiple
        multipleOf || 1
      end

      def min_int
        if minimum
          exclusiveMinimum ? minimum + 1 : minimum
        else
          1
        end
      end

      def max_int
        if maximum
          exclusiveMaximum ? maximum - 1 : maximum
        else
          BIG_INT
        end
      end
    end
  end
end
