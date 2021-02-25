module Fakeit
  module Middleware
    class Recorder
      def initialize(app) = @app = app

      def call(env)
        env
          .tap(&method(:log_request))
          .then { @app.call(_1) }
          .tap(&method(:log_response))
      end

      private

      def log_request(env)
        env['rack.input']
          &.tap { |body| Logger.info("Request body: #{body.read}") }
          &.tap { |body| body.rewind }
      end

      def log_response(response) = Logger.info("Response body: #{response[2].first}")
    end
  end
end
