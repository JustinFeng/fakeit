module Fakeit::Openapi
  class Specification
    def initialize(doc)
      @doc = doc
    end

    def operation(method, path)
      @doc.request_operation(method, path)
          &.then(&Operation.method(:new))
    end
  end
end
