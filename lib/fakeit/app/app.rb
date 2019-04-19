module Fakeit::App
  class << self
    def create(spec_file)
      specification = Fakeit::Openapi.load(spec_file)

      proc do |env|
        specification
          .operation(env['REQUEST_METHOD'].downcase.to_sym, env['PATH_INFO'])
          .then(&method(:rack_response))
      end
    end

    private

    def rack_response(operation)
      if operation
        [operation.status, operation.headers, [operation.body]]
      else
        [404, {}, ['Not Found']]
      end
    end
  end
end
