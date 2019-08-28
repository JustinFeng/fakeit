module Fakeit
  module Openapi
    module Example
      MIN_NUM = -2**31
      MAX_NUM = 2**31 - 1

      def number_example(example_options)
        if example_options[:use_static][type: 'number', property: example_options[:property]]
          static_number_example
        else
          random_number_example
        end
      end

      private

      def static_number_example
        (num_rand_end * num_multiple)
          .then { |result| multipleOf ? result : result.round(2) }
      end

      def random_number_example
        (Faker::Number.between(from: num_rand_begin, to: num_rand_end) * num_multiple)
          .then { |result| multipleOf ? result : result.round(2) }
      end

      def num_rand_begin
        multipleOf ? (min_num / multipleOf).ceil : min_num
      end

      def num_rand_end
        multipleOf ? (max_num / multipleOf).floor : max_num
      end

      def num_multiple
        multipleOf || 1
      end

      def min_num
        (minimum || MIN_NUM).to_f.ceil(2)
      end

      def max_num
        (maximum || MAX_NUM).to_f.floor(2)
      end
    end
  end
end
