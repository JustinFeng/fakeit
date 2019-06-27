module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example, :allow_cors

      def initialize(permissive: false, use_example: false, allow_cors: false)
        @permissive = permissive
        @use_example = use_example
        @allow_cors = allow_cors
      end
    end
  end
end
