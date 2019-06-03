module Fakeit
  module Openapi
    module Example
      MAX_SIZE = 50

      def array_example(use_example)
        Array.new(Faker::Number.between(minItems || 1, maxItems || MAX_SIZE)) do
          items.to_example(use_example)
        end
      end
    end
  end
end
