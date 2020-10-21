module Fakeit
  module App
    class << self
      def create(spec_file, options)
        config_route = Routes::ConfigRoute.new(options)
        openapi_route = Routes::OpenapiRoute.new(spec_file)

        proc do |env|
          request = Rack::Request.new(env)

          case request.path_info
          when '/__fakeit_config__'
            config_route.call(request)
          else
            openapi_route.call(request, config_route.options)
          end
        end
      end
    end
  end
end
