module Fakeit
  module App
    class Options
      attr_reader :permissive, :use_example

      def initialize(permissive: false, use_example: false)
        @permissive = permissive
        @use_example = use_example
      end
    end
  end
end
