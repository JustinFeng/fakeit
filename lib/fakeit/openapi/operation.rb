module Fakeit::Openapi
  class Operation
    def initialize(request_operation)
      @request_operation = request_operation
    end

    def status
      @request_operation.operation_object.responses.response.keys.first.to_i
    end

    def headers
      {
        'Content-Type' => @request_operation.operation_object.responses.response.values.first.content.keys.first
      }
    end

    def body
      @request_operation.operation_object.responses.response.values.first.content.values.first.schema.to_example
    end
  end
end
