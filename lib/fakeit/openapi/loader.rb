module Fakeit
  module Openapi
    class << self
      def load(src)
        parse_method = parse_method(src)

        URI
          .open(src, &:read)
          .then(&parse_method)
          .then(&OpenAPIParser.method(:parse))
      end

      private

      def parse_method(src)
        case File.extname(src)
        when '.json'
          JSON.method(:parse)
        when '.yml', '.yaml'
          YAML.method(:safe_load)
        else
          raise 'Invalid openapi specification file'
        end
      end
    end
  end
end
