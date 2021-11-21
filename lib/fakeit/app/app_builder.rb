module Fakeit
  module App
    class AppBuilder
      def initialize(spec_file, options)
        @options = options
        @config_route = Routes::ConfigRoute.new(options)
        @openapi_route = Routes::OpenapiRoute.new(spec_file)
      end

      def build
        proc do |env|
          request = Rack::Request.new(env)

          case request.path_info
          when '/__fakeit_config__'
            @config_route.call(request)
          else
            request.path_info = trim_base_from_path(request.path_info)
            @openapi_route.call(request, @config_route.options)
          end
        end
      end

      private

      def trim_base_from_path(path)
        return path if @options.base_path == '/'

        return path unless path.start_with?(@options.base_path)

        path[@options.base_path.length - 1..]
      end
    end
  end
end
