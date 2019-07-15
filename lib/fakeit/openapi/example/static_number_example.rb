module Fakeit
  module Openapi
    module Example
      def static_number_example
        (num_rand_begin * num_multiple)
          .then { |result| multipleOf ? result : result.round(2) }
      end
    end
  end
end
