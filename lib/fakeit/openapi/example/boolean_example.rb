module Fakeit
  module Openapi
    module Example
      def boolean_example(example_options)
        example_options[:use_static][type: 'boolean', property: example_options[:property]] || Faker::Boolean.boolean
      end
    end
  end
end
