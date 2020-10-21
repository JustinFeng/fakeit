module Fakeit
  module App
    module Helpers
      class ResponseBuilder
        HEADERS = { 'Content-Type' => 'application/json' }.freeze

        class << self
          def error(code, err)
            [code, { 'Content-Type' => 'application/json' }, [{ message: err.message }.to_json]]
          end

          def not_found
            [404, {}, ['Not Found']]
          end

          def method_not_allowed
            [405, {}, ['Method Not Allowed']]
          end

          def ok(body)
            [200, HEADERS, [body.to_json]]
          end
        end
      end
    end
  end
end
