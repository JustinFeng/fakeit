module Fakeit
  module Openapi
    module Example
      def string_example
        if enum
          enum.to_a.sample
        elsif pattern
          Faker::Base.regexify(pattern)
        elsif format == 'uri'
          Faker::Internet.url
        else
          Faker::Book.title
        end
      end
    end
  end
end
