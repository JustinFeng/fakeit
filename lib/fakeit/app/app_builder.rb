module Fakeit
  module App
    class AppBuilder
      def initialize(spec_file, options)
        @config_route = Routes::ConfigRoute.new(options)
        @openapi_route = Routes::OpenapiRoute.new(spec_file)
      end

      def build
        proc do |env|
          request = Rack::Request.new(env)
          base_path = @config_route.options.base_path
          path_info = request.path_info

          if path_info == '/__fakeit_config__'
            config(request)
          elsif path_info.start_with?(base_path)
            openapi(request, path_info[(base_path.length - 1)..])
          elsif "#{path_info}/" == base_path
            openapi(request, '/')
          else
            Fakeit::App::Helpers::ResponseBuilder.not_found
          end
        end
      end

      private

      def config(request)
        @config_route.call(request)
      end

      def openapi(request, path_info)
        request.path_info = path_info
        @openapi_route.call(request, @config_route.options)
      end
    end
  end
end
