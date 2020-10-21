module Fakeit
  module App
    class << self
      def create(spec_file, options)
        openapi_route = Routes::OpenapiRoute.new(spec_file)

        proc do |env|
          request = Rack::Request.new(env)

          openapi_route.call(request, options)
        end
      end
    end
  end
end
