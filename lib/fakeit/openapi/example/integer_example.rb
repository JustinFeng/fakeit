module Fakeit
  module Openapi
    module Example
      BIG_INT = 2**32

      def integer_example
        if enum
          enum.to_a.sample
        else
          Faker::Number.between(min_int, max_int)
        end
      end

      private

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
