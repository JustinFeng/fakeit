module Fakeit
  module Openapi
    module Example
      def static_integer_example
        if enum
          enum.to_a.first
        else
          int_rand_begin * int_multiple
        end
      end
    end
  end
end
