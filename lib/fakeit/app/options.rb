module Fakeit
  module App
    class Options
      attr_reader :permissive

      def initialize(permissive: false)
        @permissive = permissive
      end
    end
  end
end
