module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example, :static

      def initialize(permissive: false, use_example: false, static: false)
        @permissive = permissive
        @use_example = use_example
        @static = static
      end
    end
  end
end
