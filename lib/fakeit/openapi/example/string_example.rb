module Fakeit
  module Openapi
    module Example
      FORMAT_HANDLERS = {
        'uri' => -> { Faker::Internet.url },
        'uuid' => -> { SecureRandom.uuid },
        'email' => -> { Faker::Internet.email },
        'date' => -> { Faker::Date.backward(100).iso8601 },
        'date-time' => -> { Faker::Time.backward(100).iso8601 }
      }.freeze

      def string_example
        if enum then enum.to_a.sample
        elsif pattern then Faker::Base.regexify(pattern)
        elsif format then string_format
        elsif length_constraint then string_with_length
        else Faker::Book.title
        end
      end

      private

      def length_constraint
        minLength || maxLength
      end

      def string_with_length
        Faker::Internet.user_name(min_string_length..max_string_length)
      end

      def min_string_length
        minLength || 0
      end

      def max_string_length
        maxLength || min_string_length + 10
      end

      def string_format
        (FORMAT_HANDLERS[format] || method(:unknown_format))[]
      end

      def unknown_format
        Fakeit::Logger.warn("Unknown string format: #{format}")
        'Unknown string format'
      end
    end
  end
end
