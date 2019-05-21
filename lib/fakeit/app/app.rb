module Fakeit
  module App
    class << self
      def create(spec_file)
        specification = Fakeit::Openapi.load(spec_file)

        proc do |env|
          request = Rack::Request.new(env)
          specification
            .operation(request.request_method.downcase.to_sym, request.path_info)
            &.tap { |operation| validate(operation, request) }
            .then(&method(:rack_response))
        rescue Fakeit::Validation::ValidationError => e
          error_response(e)
        end
      end

      private

      def error_response(err)
        { message: err.message }
          .to_json
          .then { |message| [418, { 'Content-Type' => 'application/json' }, [message]] }
      end

      def rack_response(operation)
        if operation
          [operation.status, operation.headers, [operation.body]]
        else
          [404, {}, ['Not Found']]
        end
      end

      def validate(operation, request)
        operation.validate(
          body: request.body&.read.to_s,
          params: request.params
        )
      end
    end
  end
end
