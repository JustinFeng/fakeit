module Fakeit
  module Openapi
    class << self
      def load(src)
        URI
          .open(src, &:read)
          .then { parse(src, _1) }
          .then(&OpenAPIParser.method(:parse))
      end

      private

      def parse(src, content)
        case File.extname(src)
        when '.json'
          JSON.parse(content)
        when '.yml', '.yaml'
          YAML.safe_load(content, [Date, Time])
        else
          raise 'Invalid openapi specification file'
        end
      end
    end
  end
end
