module Fakeit::Openapi
  class Operation
    def initialize(request_operation)
      @request_operation = request_operation
    end

    def status
      openapi_response.first.to_i
    end

    def headers
      openapi_headers&.map { |k, v| [k, v.schema.to_example] }.to_h
    end

    def body
      openapi_content&.schema&.to_example&.then(&JSON.method(:generate)).to_s
    end

    private

    def openapi_content
      openapi_response.last.content&.first&.last
    end

    def openapi_headers
      openapi_response.last.headers
    end

    def openapi_response
      @request_operation.operation_object.responses.response.first
    end
  end
end
