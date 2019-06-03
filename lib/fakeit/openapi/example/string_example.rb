module Fakeit
  module Openapi
    module Example
      def string_example
        if enum
          enum.to_a.sample
        elsif pattern
          Faker::Base.regexify(pattern)
        elsif format
          string_format
        else
          Faker::Book.title
        end
      end

      private

      def string_format
        case format
        when 'uri' then Faker::Internet.url
        when 'uuid' then SecureRandom.uuid
        end
      end
    end
  end
end
