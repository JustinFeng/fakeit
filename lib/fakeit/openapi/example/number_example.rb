module Fakeit
  module Openapi
    module Example
      BIG_NUM = 2**32

      def number_example
        Faker::Number.between(min_num, max_num).round(2)
      end

      private

      def min_num
        (minimum || 0).to_f.ceil(2)
      end

      def max_num
        (maximum || BIG_NUM).to_f.floor(2)
      end
    end
  end
end
