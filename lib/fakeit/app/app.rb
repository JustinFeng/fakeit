module Fakeit::App
  class << self
    def create(spec_file)
      specification = Fakeit::Openapi.load(spec_file)

      proc do |env|
        specification
          .operation(env['REQUEST_METHOD'].downcase.to_sym, env['PATH_INFO'])
          .then { |operation| [operation.status, operation.headers, [operation.body]] }
      end
    end
  end
end
