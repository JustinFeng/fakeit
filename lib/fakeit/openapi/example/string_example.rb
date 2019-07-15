module Fakeit
  module Openapi
    module Example
      STATIC_FORMAT_HANDLERS = {
        'uri' => -> { 'https://some.uri' },
        'uuid' => -> { '11111111-1111-1111-1111-111111111111' },
        'guid' => -> { '11111111-1111-1111-1111-111111111111' },
        'email' => -> { 'some@email.com' },
        'date' => -> { Date.today.iso8601 },
        'date-time' => lambda do
          now = Time.now
          Time.new(now.year, now.month, now.day, 0, 0, 0, now.utc_offset).iso8601
        end
      }.freeze

      RANDOM_FORMAT_HANDLERS = {
        'uri' => -> { Faker::Internet.url },
        'uuid' => -> { SecureRandom.uuid },
        'guid' => -> { SecureRandom.uuid },
        'email' => -> { Faker::Internet.email },
        'date' => -> { Faker::Date.backward(100).iso8601 },
        'date-time' => -> { Faker::Time.backward(100).iso8601 }
      }.freeze

      def string_example(example_options)
        example_options[:static] ? static_string_example : random_string_example
      end

      private

      def static_string_example
        Faker::Config.random = Random.new(1) # Fix seed for faker

        if enum then enum.to_a.first
        elsif pattern then Faker::Base.regexify(pattern)
        elsif format then static_string_format
        elsif length_constraint then static_string_with_length
        else 'string'
        end
      end

      def random_string_example
        if enum then enum.to_a.sample
        elsif pattern then Faker::Base.regexify(pattern)
        elsif format then random_string_format
        elsif length_constraint then string_with_length
        else Faker::Book.title
        end
      end

      def static_string_with_length
        '1' * max_string_length
      end

      def static_string_format
        (STATIC_FORMAT_HANDLERS[format] || method(:unknown_format))[]
      end

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

      def random_string_format
        (RANDOM_FORMAT_HANDLERS[format] || method(:unknown_format))[]
      end

      def unknown_format
        Fakeit::Logger.warn("Unknown string format: #{format}")
        'Unknown string format'
      end
    end
  end
end
