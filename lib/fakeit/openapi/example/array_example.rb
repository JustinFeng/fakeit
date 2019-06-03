module Fakeit
  module Openapi
    module Example
      def array_example(use_example)
        [items.to_example(use_example)]
      end
    end
  end
end
