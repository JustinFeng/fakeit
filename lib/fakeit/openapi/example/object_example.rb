module Fakeit
  module Openapi
    module Example
      def object_example(use_example)
        properties.each_with_object({}) { |(name, schema), obj| obj[name] = schema.to_example(use_example) }
      end
    end
  end
end
