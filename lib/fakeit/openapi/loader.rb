module Fakeit
  module Openapi
    class << self
      def load(src)
        parse_method = parse_method(src)

        open(src, &:read)
          .then(&parse_method)
          .then(&OpenAPIParser.method(:parse))
          .then(&Specification.method(:new))
      end

      private

      def parse_method(src)
        case File.extname(src)
        when '.json' then
          JSON.method(:parse)
        when '.yml', '.yaml' then
          YAML.method(:safe_load)
        else
          raise 'Invalid openapi specification file'
        end
      end
    end
  end
end
