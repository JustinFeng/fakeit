describe Fakeit::Validation::Validator do
  subject { Fakeit::Validation::Validator.new(request_operation) }

  let(:request_operation) { double(OpenAPIParser::RequestOperation) }

  before(:each) do
    allow(request_operation).to receive(:validate_request_body)
    allow(request_operation).to receive(:validate_path_params)
    allow(request_operation).to receive(:validate_request_parameter)

    allow(request_operation).to receive_message_chain(:operation_object, :request_body, :content)
  end

  describe 'body' do
    before(:each) do
      allow(request_operation).to receive_message_chain(:operation_object, :request_body, :content)
        .and_return('text/plain' => '', 'application/vnd.api+json' => '')
    end

    it 'validates' do
      expect(request_operation).to receive(:validate_request_body).with('application/vnd.api+json', 'request' => 'body')

      subject.validate(body: '{"request": "body"}')
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_body).and_raise(StandardError.new('some error'))

      expect { subject.validate(body: '{"request": "body"}') }
        .to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end

    it 'does not validate when json content type not found' do
      allow(request_operation).to receive_message_chain(:operation_object, :request_body, :content).and_return(nil)

      expect(request_operation).not_to receive(:validate_request_body)

      subject.validate(body: '{"request": "body"}')
    end

    it 'does not validate when body is invalid json and content type is not json' do
      allow(request_operation).to receive_message_chain(:operation_object, :request_body, :content).and_return(nil)

      expect(request_operation).not_to receive(:validate_request_body)

      subject.validate(body: 'not a json')
    end

    it 'raise validation error when body is invalid json but content type is json' do
      expect { subject.validate(body: 'not a json') }
        .to raise_error(Fakeit::Validation::ValidationError, 'Invalid json payload')
    end
  end

  describe 'path params' do
    let(:options) { double(OpenAPIParser::SchemaValidator::Options) }

    it 'validates' do
      expect(OpenAPIParser::SchemaValidator::Options).to receive(:new).with(coerce_value: true).and_return(options)
      expect(request_operation).to receive(:validate_path_params).with(options)

      subject.validate(params: {})
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_path_params).and_raise(StandardError.new('some error'))

      expect { subject.validate(params: {}) }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end

  describe 'query params' do
    let(:options) { double(OpenAPIParser::SchemaValidator::Options) }
    let(:params) { { 'some' => 'param' } }

    it 'validates' do
      expect(OpenAPIParser::SchemaValidator::Options).to receive(:new).with(coerce_value: true).and_return(options)
      expect(request_operation).to receive(:validate_request_parameter).with(params, {}, options)

      subject.validate(params: params)
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_parameter).and_raise(StandardError.new('some error'))

      expect { subject.validate(params: params) }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end

  describe 'headers' do
    let(:options) { double(OpenAPIParser::SchemaValidator::Options) }
    let(:headers) { { 'some' => 'header' } }

    it 'validates' do
      expect(OpenAPIParser::SchemaValidator::Options).to receive(:new).with(coerce_value: true).and_return(options)
      expect(request_operation).to receive(:validate_request_parameter).with({}, headers, options)

      subject.validate(headers: headers)
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_parameter).and_raise(StandardError.new('some error'))

      expect { subject.validate(headers: headers) }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end
end
