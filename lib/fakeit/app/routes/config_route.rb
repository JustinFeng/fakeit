module Fakeit
  module App
    module Routes
      class ConfigRoute
        attr_reader :options

        def initialize(options)
          @options = options
        end

        def call(request)
          case [request.request_method, request.media_type]
          in ['GET', _]
            Fakeit::App::Helpers::ResponseBuilder.ok(@options.to_hash)
          in ['PUT', %r{^application/.*json}]
            update(request)
          in ['PUT', _]
            Fakeit::App::Helpers::ResponseBuilder.unsupported_media_type
          else
            Fakeit::App::Helpers::ResponseBuilder.method_not_allowed
          end
        end

        private

        def update(request)
          body = Fakeit::App::Helpers::BodyParser.parse(request)[:data]
          @options = Fakeit::App::Options.new(**body.transform_keys(&:to_sym))

          Fakeit::App::Helpers::ResponseBuilder.ok(@options.to_hash)
        rescue ArgumentError => e
          Fakeit::Logger.warn(Rainbow(e.message).red)
          Fakeit::App::Helpers::ResponseBuilder.error(422, e)
        end
      end
    end
  end
end
