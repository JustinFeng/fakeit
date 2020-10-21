module Fakeit
  module App
    module Routes
      class ConfigRoute
        attr_reader :options

        HEADERS = { 'Content-Type' => 'application/json' }.freeze

        def initialize(options)
          @options = options
        end

        def call(request)
          case request.request_method
          when 'GET'
            [200, HEADERS, @options.to_hash.to_json]
          when 'PUT'
            update(request)
          else
            [405, {}, ['Method Not Allowed']]
          end
        end

        private

        def update(request)
          config = Fakeit::App::Helpers::BodyParser.parse(request)
          @options = Fakeit::App::Options.new(**config)

          [200, HEADERS, @options.to_hash.to_json]
        rescue ArgumentError => e
          Fakeit::Logger.warn(Rainbow(e.message).red)
          [422, HEADERS, [{ message: e.message }.to_json]]
        end
      end
    end
  end
end
