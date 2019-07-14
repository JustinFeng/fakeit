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

      def static_string_example
        Faker::Config.random = Random.new(1) # Fix seed for faker

        if enum then enum.to_a.first
        elsif pattern then Faker::Base.regexify(pattern)
        elsif format then static_string_format
        elsif length_constraint then static_string_with_length
        else 'string'
        end
      end

      private

      def static_string_with_length
        '1' * max_string_length
      end

      def static_string_format
        (STATIC_FORMAT_HANDLERS[format] || method(:unknown_format))[]
      end
    end
  end
end
