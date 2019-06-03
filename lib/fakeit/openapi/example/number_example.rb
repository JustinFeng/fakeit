module Fakeit
  module Openapi
    module Example
      def number_example
        Faker::Number.decimal.to_f
      end
    end
  end
end
