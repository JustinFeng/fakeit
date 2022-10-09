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
          options = @config_route.options
          path_info = request.path_info

          if path_info == '/__fakeit_config__'
            @config_route.call(request)
          elsif path_info.start_with?(options.base_path)
            request.path_info = path_info[options.base_path.length - 1..]
            @openapi_route.call(request, options)
          elsif "#{path_info}/" == options.base_path
            request.path_info = '/'
            @openapi_route.call(request, options)
          else
            Fakeit::App::Helpers::ResponseBuilder.not_found
          end
        end
      end
    end
  end
end
