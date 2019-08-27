module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example

      def initialize(permissive: false, use_example: false, static: false, static_types: [])
        @permissive = permissive
        @use_example = use_example
        @static = static
        @static_types = static_types
      end

      def use_static?(type: nil)
        @static || @static_types.include?(type)
      end
    end
  end
end
