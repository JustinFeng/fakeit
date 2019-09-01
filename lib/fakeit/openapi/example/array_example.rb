module Fakeit
  module Openapi
    module Example
      def array_example(options)
        example_options = add_depth(options)
        if example_options[:use_static][type: 'array', property: example_options[:property]]
          static_array_example(example_options)
        else
          random_array_example(example_options)
        end
      end

      private

      def static_array_example(example_options)
        size = retries = min_array
        [].tap { |result| generate_items(size, retries, example_options, result) }
      end

      def random_array_example(example_options)
        size = retries = random_array_size(example_options)
        [].tap { |result| generate_items(size, retries, example_options, result) }
      end

      def random_array_size(example_options)
        uniqueItems ? min_array : Faker::Number.between(from: min_array, to: max_array(example_options[:depth]))
      end

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

      def add_depth(example_options)
        { **example_options, depth: example_options[:depth] + 1 }
      end

      def need_retry?(item, result, retries)
        uniqueItems && result.include?(item) && retries.positive?
      end

      def min_array
        minItems || 1
      end

      def max_array(depth)
        maxItems || min_array + (depth > 1 ? 2 : 9)
      end
    end
  end
end
