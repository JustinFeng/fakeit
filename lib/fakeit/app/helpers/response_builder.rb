module Fakeit
  module App
    module Helpers
      class ResponseBuilder
        class << self
          def error(code, err) = [code, { 'Content-Type' => 'application/json' }, [{ message: err.message }.to_json]]

          def not_found = [404, {}, ['Not Found']]

          def method_not_allowed = [405, {}, ['Method Not Allowed']]

          def unsupported_media_type = [415, {}, ['Unsupported Media Type']]

          def ok(body) = [200, { 'Content-Type' => 'application/json' }, [body.to_json]]
        end
      end
    end
  end
end
