describe Fakeit::Openapi::Specification do
  subject { Fakeit::Openapi::Specification.new(doc) }

  let(:doc) { double(OpenAPIParser::Schemas::OpenAPI) }
  let(:request_operation) { double(OpenAPIParser::RequestOperation) }
  let(:operation) { double(Fakeit::Openapi::Operation) }
  let(:options) { double(Fakeit::App::Options) }

  let(:method) { :get }
  let(:path) { '/' }

  it 'gets matching operation' do
    allow(doc).to receive(:request_operation).with(method, path).and_return(request_operation)
    allow(Fakeit::Openapi::Operation).to receive(:new).with(request_operation, options).and_return(operation)

    expect(subject.operation(method, path, options)).to be(operation)
  end

  it 'returns nil when no matching operation' do
    allow(doc).to receive(:request_operation).with(method, path).and_return(nil)

    expect(subject.operation(method, path, options)).to be_nil
  end
end
