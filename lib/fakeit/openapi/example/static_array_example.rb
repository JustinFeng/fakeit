module Fakeit
  module Openapi
    module Example
      def static_array_example(example_options)
        size = retries = min_array
        [].tap { |result| generate_items(size, retries, example_options, result) }
      end
    end
  end
end
