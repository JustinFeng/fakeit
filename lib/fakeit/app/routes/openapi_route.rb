module Fakeit
  module App
    module Routes
      class OpenapiRoute
        def initialize(spec_file) = @specification = Fakeit::Openapi::Specification.new(spec_file)

        def call(request, options)
          @specification
            .operation(request.request_method.downcase.to_sym, request.path_info, options)
            .then { _1 ? handle(_1, request, options) : Fakeit::App::Helpers::ResponseBuilder.not_found }
        end

        private

        def handle(operation, request, options)
          validate(operation, request)
          response(operation)
        rescue Fakeit::Validation::ValidationError => e
          Logger.warn(Rainbow(e.message).red)
          options.permissive ? response(operation) : Fakeit::App::Helpers::ResponseBuilder.error(418, e)
        end

        def response(operation) = [operation.status, operation.headers, [operation.body]]

        def validate(operation, request)
          operation.validate(
            body: Helpers::BodyParser.parse(request),
            params: parse_query(request.query_string),
            headers: headers(request)
          )
        end

        def headers(request)
          request
            .each_header
            .select { |k, _| k.start_with? 'HTTP_' }
            .to_h { |k, v| [k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-'), v] }
        end

        def parse_query(query_string)
          rack_query = Rack::Utils.parse_nested_query(query_string)
          cgi_query = CGI.parse(query_string)

          rack_query.merge(cgi_query.slice(*rack_query.keys)) do |_, oldval, newval|
            newval.is_a?(Array) && newval.size > 1 ? newval : oldval
          end
        end
      end
    end
  end
end
