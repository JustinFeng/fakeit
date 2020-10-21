module Fakeit
  module App
    module Routes
      class ConfigRoute
        attr_reader :options

        def initialize(options)
          @options = options
        end

        def call(request)
          case request.request_method
          when 'GET'
            Fakeit::App::Helpers::ResponseBuilder.ok(@options.to_hash)
          when 'PUT'
            update(request)
          else
            Fakeit::App::Helpers::ResponseBuilder.method_not_allowed
          end
        end

        private

        def update(request)
          data = Fakeit::App::Helpers::BodyParser.parse(request)[:data]
          config = data.transform_keys(&:to_sym)
          @options = Fakeit::App::Options.new(**config)

          Fakeit::App::Helpers::ResponseBuilder.ok(@options.to_hash)
        rescue ArgumentError => e
          Fakeit::Logger.warn(Rainbow(e.message).red)
          Fakeit::App::Helpers::ResponseBuilder.error(422, e)
        end
      end
    end
  end
end
