module Fakeit
  module Openapi
    module Example
      MAX_SIZE = 50

      def array_example(use_example)
        size = retries = uniqueItems ? min_array : Faker::Number.between(min_array, max_array)

        generate_items(size, retries, use_example)
      end

      private

      def generate_items(size, retries, use_example)
        result = []

        loop do
          item = items.to_example(use_example)

          if need_retry?(item, result, retries)
            retries -= 1
            next
          end

          break if (result << item).size >= size
        end

        result
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
