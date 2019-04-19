require 'fakeit/openapi/operation'

describe Fakeit::Openapi::Operation do
  let(:request_operation) { double(OpenAPIParser::RequestOperation) }
  let(:response) { double(OpenAPIParser::Schemas::Response) }
  let(:media_type) { double(OpenAPIParser::Schemas::MediaType) }
  let(:body) { 'example' }

  subject { Fakeit::Openapi::Operation.new(request_operation) }

  before(:each) do
    allow(request_operation)
      .to receive_message_chain(:operation_object, :responses, :response) { { '200' => response } }
    allow(response).to receive(:content).and_return('application/json' => media_type)
    allow(media_type).to receive_message_chain(:schema, :to_example) { body }
  end

  it 'returns status' do
    expect(subject.status).to be(200)
  end

  it 'returns headers' do
    expect(subject.headers).to eq('Content-Type' => 'application/json')
  end

  it 'returns body' do
    expect(subject.body).to eq(body)
  end
end
