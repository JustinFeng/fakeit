module Fakeit
  module App
    module Helpers
      class BodyParser
        class << self
          def parse(request)
            case request.media_type
            when %r{^application/.*json}
              { media_type: request.media_type, data: parse_json(request.body.read) }
            when 'multipart/form-data'
              { media_type: request.media_type, data: parse_form_data(request.params) }
            else
              { media_type: request.media_type, data: request.body.read }
            end
          end

          private

          def parse_json(body)
            body.empty? ? {} : JSON.parse(body)
          rescue StandardError
            raise Fakeit::Validation::ValidationError, 'Invalid json payload'
          end

          def parse_form_data(params)
            params.transform_values { |v| v.class == Hash && v[:tempfile] ? v[:tempfile].read : v }
          end
        end
      end
    end
  end
end
