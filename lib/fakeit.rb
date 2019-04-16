module Fakeit
  class << self
    def build
      Rack::Builder.new do
        app = proc do |_|
          [200, {}, ['OK']]
        end

        run app
      end
    end
  end
end
