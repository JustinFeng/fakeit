module Fakeit
  module Openapi
    module Example
      BIG_INT = 2**32

      def integer_example
        if enum
          enum.to_a.sample
        else
          Faker::Number.between(minimum || 1, maximum || BIG_INT)
        end
      end
    end
  end
end
