module Fakeit
  module Openapi
    module Example
      MAX_SIZE = 3

      def array_example(example_options)
        size = retries = uniqueItems ? min_array : Faker::Number.between(min_array, max_array)
        [].tap { |result| generate_items(size, retries, example_options, result) }
      end

      private

      def generate_items(size, retries, example_options, result)
        loop do
          item = items.to_example(example_options)

          if need_retry?(item, result, retries)
            retries -= 1
          elsif (result << item).size >= size
            break
          end
        end
      end

      def need_retry?(item, result, retries)
        uniqueItems && result.include?(item) && retries.positive?
      end

      def min_array
        minItems || 1
      end

      def max_array
        maxItems || MAX_SIZE
      end
    end
  end
end
