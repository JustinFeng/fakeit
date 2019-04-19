require 'fakeit/app/app'

module Fakeit
  class << self
    def build(spec_file)
      Rack::Builder.new do
        run Fakeit::App.create(spec_file)
      end
    end
  end
end
