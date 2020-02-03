module Fakeit
  module App
    class << self
      def create(spec_file, options)
        specification = Fakeit::Openapi::Specification.new(spec_file)

        proc do |env|
          request = Rack::Request.new(env)
          specification
            .operation(request.request_method.downcase.to_sym, request.path_info, options)
            .then { _1 ? handle(_1, request, options) : not_found }
        end
      end

      private

      def handle(operation, request, options)
        validate(operation, request)
        response(operation)
      rescue Fakeit::Validation::ValidationError => e
        Fakeit::Logger.warn(Rainbow(e.message).red)
        options.permissive ? response(operation) : error(e)
      end

      def error(err)
        [418, { 'Content-Type' => 'application/json' }, [{ message: err.message }.to_json]]
      end

      def not_found
        [404, {}, ['Not Found']]
      end

      def response(operation)
        [operation.status, operation.headers, [operation.body]]
      end

      def validate(operation, request)
        operation.validate(
          body: request.body&.read.to_s,
          params: parse_query(request.query_string),
          headers: headers(request)
        )
      end

      def headers(request)
        request
          .each_header
          .select { |k, _| k.start_with? 'HTTP_' }
          .map { |k, v| [k.sub(/^HTTP_/, '').split('_').map(&:capitalize).join('-'), v] }
          .to_h
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
