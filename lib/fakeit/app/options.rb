module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example, :base_path

      def initialize(
        permissive: false,
        use_example: false,
        static: false,
        static_types: [],
        static_properties: [],
        base_path: nil
      )
        @permissive = permissive
        @use_example = use_example
        @static = static
        @static_types = static_types
        @static_properties = static_properties
        # Standardize the base path to include trailing slash
        # so that `/base` matches `/base/path` but doesn't match `/basement/path`
        @base_path =
          if base_path.nil?
            '/'
          elsif base_path[-1] == '/'
            base_path
          else
            "#{base_path}/"
          end
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
          static_properties: @static_properties,
          base_path: @base_path
        }
      end
    end
  end
end
