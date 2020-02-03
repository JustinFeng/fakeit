module Fakeit
  module Openapi
    class Specification
      def initialize(spec_file)
        @spec_file = spec_file
        @mtime = File.mtime(spec_file) if File.exist?(spec_file)
        @doc = Fakeit::Openapi.load(spec_file)
      end

      def operation(method, path, options)
        reload_spec if @mtime

        @doc
          .request_operation(method, path)
          &.then { Operation.new(_1, options) }
      end

      private

      def reload_spec
        new_mtime = File.mtime(@spec_file)

        return if @mtime == new_mtime

        @mtime = new_mtime
        @doc = Fakeit::Openapi.load(@spec_file)
      rescue StandardError => _e
        Fakeit::Logger.warn(Rainbow('Invalid spec file, use previous snapshot instead').red)
      end
    end
  end
end
