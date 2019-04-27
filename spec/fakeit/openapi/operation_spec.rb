describe Fakeit::Openapi::Operation do
  subject { Fakeit::Openapi::Operation.new(request_operation) }

  let(:request_operation) { double(OpenAPIParser::RequestOperation) }
  let(:response) { double(OpenAPIParser::Schemas::Response) }
  let(:media_type) { double(OpenAPIParser::Schemas::MediaType) }
  let(:header_1) { double(OpenAPIParser::Schemas::Header) }
  let(:header_2) { double(OpenAPIParser::Schemas::Header) }

  let(:body) { { 'some' => 'body' } }
  let(:header_1_value) { '1' }
  let(:header_2_value) { '2' }

  before(:each) do
    allow(request_operation)
      .to receive_message_chain(:operation_object, :responses, :response) { { '200' => response } }
  end

  it 'returns status' do
    expect(subject.status).to be(200)
  end

  it 'returns headers' do
    allow(response).to receive(:headers).and_return('header_1' => header_1, 'header_2' => header_2)
    allow(header_1).to receive_message_chain(:schema, :to_example) { header_1_value }
    allow(header_2).to receive_message_chain(:schema, :to_example) { header_2_value }

    expect(subject.headers).to eq('header_1' => header_1_value, 'header_2' => header_2_value)
  end

  it 'returns no headers' do
    allow(response).to receive(:headers).and_return(nil)

    expect(subject.headers).to eq({})
  end

  it 'returns body' do
    allow(response).to receive(:content).and_return('application/json' => media_type)
    allow(media_type).to receive_message_chain(:schema, :to_example) { body }

    expect(subject.body).to eq(JSON.generate(body))
  end

  it 'returns no body' do
    allow(response).to receive(:content).and_return(nil)

    expect(subject.body).to eq('')
  end
end
