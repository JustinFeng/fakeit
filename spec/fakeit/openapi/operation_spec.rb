describe Fakeit::Openapi::Operation do
  subject { Fakeit::Openapi::Operation.new(request_operation, app_options) }

  let(:app_options) { Fakeit::App::Options.new }
  let(:request_operation) { double(OpenAPIParser::RequestOperation) }
  let(:response) { double(OpenAPIParser::Schemas::Response) }
  let(:media_type) { double(OpenAPIParser::Schemas::MediaType) }
  let(:header_1) { double(OpenAPIParser::Schemas::Header) }
  let(:header_2) { double(OpenAPIParser::Schemas::Header) }
  let(:schema) { double(OpenAPIParser::Schemas::Schema) }

  let(:body) { { 'some' => 'body' } }
  let(:header_1_value) { '1' }
  let(:header_2_value) { '2' }

  before(:each) do
    allow(request_operation).to receive_message_chain(:operation_object, :responses, :response)
      .and_return('400' => 'other_response', '200' => response)
    allow(request_operation).to receive(:validate_request_body)
  end

  describe 'status' do
    it 'returns successful status' do
      expect(subject.status).to be(200)
    end
  end

  describe 'headers' do
    it 'returns headers' do
      allow(response).to receive(:headers).and_return('header_1' => header_1, 'header_2' => header_2)
      allow(response).to receive(:content).and_return('application/json' => media_type)
      allow(header_1).to receive_message_chain(:schema, :to_example).and_return(header_1_value)
      allow(header_2).to receive_message_chain(:schema, :to_example).and_return(header_2_value)

      expect(subject.headers).to eq(
        'header_1' => header_1_value,
        'header_2' => header_2_value,
        'Content-Type' => 'application/json'
      )
    end

    it 'returns no Content-Type header when no content matches' do
      allow(response).to receive(:headers).and_return('header_1' => header_1, 'header_2' => header_2)
      allow(response).to receive(:content).and_return(nil)
      allow(header_1).to receive_message_chain(:schema, :to_example).and_return(header_1_value)
      allow(header_2).to receive_message_chain(:schema, :to_example).and_return(header_2_value)

      expect(subject.headers).to eq(
        'header_1' => header_1_value,
        'header_2' => header_2_value
      )
    end

    it 'only returns Content-Type header when no custom headers defined' do
      allow(response).to receive(:headers).and_return(nil)
      allow(response).to receive(:content).and_return('application/json' => media_type)

      expect(subject.headers).to eq('Content-Type' => 'application/json')
    end

    it 'returns no headers' do
      allow(response).to receive(:headers).and_return(nil)
      allow(response).to receive(:content).and_return(nil)

      expect(subject.headers).to eq({})
    end
  end

  describe 'body' do
    it 'returns body for application/json' do
      allow(response).to receive(:content).and_return(
        'text/plain' => 'other_media_type', 'application/json' => media_type
      )
      allow(media_type).to receive(:schema).and_return(schema)

      expect(schema).to receive(:to_example).with(use_example: false, static: false, depth: 0).and_return(body)
      expect(subject.body).to eq(JSON.generate(body))
    end

    it 'returns body for vendor defined json' do
      allow(response).to receive(:content).and_return(
        'text/plain' => 'other_media_type', 'application/vnd.api+json' => media_type
      )
      allow(media_type).to receive(:schema).and_return(schema)

      expect(schema).to receive(:to_example).with(use_example: false, static: false, depth: 0).and_return(body)
      expect(subject.body).to eq(JSON.generate(body))
    end

    it 'returns no body' do
      allow(response).to receive(:content).and_return(nil)

      expect(subject.body).to eq('')
    end
  end

  describe 'validate' do
    let(:validator) { double(Fakeit::Validation::Validator) }
    let(:body) { 'body' }
    let(:params) { 'params' }
    let(:headers) { 'headers' }

    before(:each) do
      allow(Fakeit::Validation::Validator).to receive(:new).with(request_operation).and_return(validator)
    end

    it 'validates request' do
      expect(validator).to receive(:validate).with(body: body, params: params, headers: headers)

      subject.validate(body: body, params: params, headers: headers)
    end
  end
end
