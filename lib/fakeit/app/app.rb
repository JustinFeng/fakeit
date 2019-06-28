module Fakeit
  module App
    class << self
      def create(spec_file, options)
        specification = Fakeit::Openapi.load(spec_file)

        proc do |env|
          request = Rack::Request.new(env)
          specification
            .operation(request.request_method.downcase.to_sym, request.path_info, options)
            .then { |operation| operation ? handle(operation, request, options) : not_found }
        end
      end

      private

      def handle(operation, request, options)
        validate(operation, request)
        response(operation)
      rescue Fakeit::Validation::ValidationError => e
        if options.permissive
          Fakeit::Logger.warn(e.message)
          response(operation)
        else
          error(e)
        end
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
          params: request.params,
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
    end
  end
end
