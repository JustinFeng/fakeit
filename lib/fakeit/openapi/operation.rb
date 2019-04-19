module Fakeit::Openapi
  class Operation
    def initialize(request_operation)
      @request_operation = request_operation
    end

    def status
      response.keys.first.to_i
    end

    def headers
      {
        'Content-Type' => content.keys.first
      }
    end

    def body
      JSON.generate(content.values.first.schema.to_example)
    end

    private

    def content
      response.values.first.content
    end

    def response
      @request_operation.operation_object.responses.response
    end
  end
end
