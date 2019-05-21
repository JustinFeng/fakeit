describe Fakeit::Validation::Validator do
  subject { Fakeit::Validation::Validator.new(request_operation) }

  let(:request_operation) { double(OpenAPIParser::RequestOperation) }

  before(:each) do
    allow(request_operation).to receive(:validate_request_body)
    allow(request_operation).to receive(:validate_path_params)
  end

  describe 'body' do
    it 'validates when not empty' do
      expect(request_operation).to receive(:validate_request_body).with('application/json', 'request' => 'body')

      subject.validate(body: '{"request": "body"}')
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_body).and_raise(StandardError.new('some error'))

      expect { subject.validate(body: '{"request": "body"}') }
        .to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end

    it 'does not validate when empty' do
      expect(request_operation).not_to receive(:validate_request_body)

      subject.validate(body: '')
    end
  end

  describe 'path params' do
    let(:options) { double(OpenAPIParser::SchemaValidator::Options) }

    it 'validates' do
      allow(OpenAPIParser::SchemaValidator::Options).to receive(:new).and_return(options)
      expect(request_operation).to receive(:validate_path_params).with(options)

      subject.validate(body: '')
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_path_params).and_raise(StandardError.new('some error'))

      expect { subject.validate(body: '') }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end
end
