module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example

      def initialize(permissive: false, use_example: false, static: false, static_types: [], static_properties: [])
        @permissive = permissive
        @use_example = use_example
        @static = static
        @static_types = static_types
        @static_properties = static_properties
      end

      def use_static?(type: nil, property: nil)
        @static || @static_types.include?(type) || @static_properties.include?(property)
      end

      def to_hash
        {
          permissive: @permissive,
          use_example: @use_example,
          static: @static,
          static_types: @static_types,
          static_properties: @static_properties
        }
      end
    end
  end
end
