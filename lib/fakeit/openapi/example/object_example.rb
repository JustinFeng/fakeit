module Fakeit
  module Openapi
    module Example
      def object_example(example_options)
        properties.each_with_object({}) do |(name, schema), obj|
          obj[name] = schema.to_example(example_options.merge(property: name))
        end
      end
    end
  end
end
