module Fakeit
  module Openapi
    module Example
      def array_example(options)
        example_options = add_depth(options)
        if example_options[:use_static][type: 'array', property: example_options[:property]]
          generate_array_example(example_options, -> { non_empty_size })
        else
          generate_array_example(example_options, -> { random_array_size(example_options) })
        end
      end

      private

      def generate_array_example(example_options, get_size)
        size = retries = get_size[]
        [].tap { generate_items(size, retries, example_options, _1) }
      end

      def random_array_size(example_options)
        uniqueItems ? non_empty_size : Faker::Number.between(from: min_array, to: max_array(example_options[:depth]))
      end

      def generate_items(size, retries, example_options, result)
        while result.size < size
          item = items.to_example(example_options)

          if need_retry?(item, result, retries)
            retries -= 1
          else
            result << item
          end
        end
      end

      def add_depth(example_options)
        { **example_options, depth: example_options[:depth] + 1 }
      end

      def need_retry?(item, result, retries)
        uniqueItems && result.include?(item) && retries.positive?
      end

      def non_empty_size
        [min_array, 1].max
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
