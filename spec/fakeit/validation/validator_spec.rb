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
    context 'request body content not exists' do
      before(:each) do
        allow(request_operation).to receive_message_chain(:operation_object, :request_body).and_return(nil)
      end

      it 'skips validation' do
        expect(request_operation).not_to receive(:validate_request_body)

        subject.validate(body: {})
      end
    end

    context 'request body content exists' do
      before(:each) do
        allow(request_operation).to receive_message_chain(:operation_object, :request_body, :content)
          .and_return(contents)
      end

      context 'media type is in request body content' do
        let(:contents) do
          {
            'application/json' => '',
            'application/vnd.api+json' => '',
            'multipart/form-data' => '',
            'text/plain' => ''
          }
        end

        context 'can validate' do
          %w[application/json application/vnd.api+json multipart/form-data].each do |media_type|
            it "validates #{media_type}" do
              expect(request_operation).to receive(:validate_request_body).with(media_type, { 'request' => 'body' })

              subject.validate(body: { media_type:, data: { 'request' => 'body' } })
            end
          end

          it 'raises validation error' do
            allow(request_operation).to receive(:validate_request_body).and_raise(StandardError.new('some error'))

            expect { subject.validate(body: { media_type: 'application/json', data: { 'request' => 'body' } }) }
              .to raise_error(Fakeit::Validation::ValidationError, 'some error')
          end
        end

        context 'cannot validate' do
          it 'skips validation' do
            expect(request_operation).not_to receive(:validate_request_body)

            subject.validate(body: { media_type: 'text/plain', data: 'body' })
          end
        end
      end

      context 'media type is not in request body content' do
        let(:contents) { { 'application/json' => '' } }

        context 'media type is nil' do
          before(:each) do
            allow(request_operation).to receive_message_chain(:operation_object, :request_body, :required)
              .and_return(required)
          end

          context 'request body is required' do
            let(:required) { true }

            it 'raises validation error' do
              expect { subject.validate(body: { media_type: nil, data: '' }) }
                .to raise_error(Fakeit::Validation::ValidationError, 'Request body is required')
            end
          end

          context 'request body is not required' do
            let(:required) { false }

            it 'skips validation' do
              expect(request_operation).not_to receive(:validate_request_body)

              subject.validate(body: { media_type: nil, data: '' })
            end
          end
        end

        context 'media type is not nil' do
          it 'raises validation error' do
            expect { subject.validate(body: { media_type: 'text/plain', data: 'body' }) }
              .to raise_error(Fakeit::Validation::ValidationError, 'Invalid request content type')
          end
        end
      end
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

      subject.validate(params:)
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_parameter).and_raise(StandardError.new('some error'))

      expect { subject.validate(params:) }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end

  describe 'headers' do
    let(:options) { double(OpenAPIParser::SchemaValidator::Options) }
    let(:headers) { { 'some' => 'header' } }

    it 'validates' do
      expect(OpenAPIParser::SchemaValidator::Options).to receive(:new).with(coerce_value: true).and_return(options)
      expect(request_operation).to receive(:validate_request_parameter).with({}, headers, options)

      subject.validate(headers:)
    end

    it 'raises validation error' do
      allow(request_operation).to receive(:validate_request_parameter).and_raise(StandardError.new('some error'))

      expect { subject.validate(headers:) }.to raise_error(Fakeit::Validation::ValidationError, 'some error')
    end
  end
end
