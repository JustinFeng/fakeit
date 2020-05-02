describe Fakeit::App::BodyParser do
  let(:request) do
    Rack::Request.new(Rack::MockRequest.env_for('', { 'CONTENT_TYPE' => content_type, input: input }))
  end

  subject { Fakeit::App::BodyParser.parse(request) }

  context 'application/json' do
    let(:content_type) { 'application/json' }

    context 'valid' do
      let(:input) { '{}' }

      it { is_expected.to eq({ media_type: 'application/json', data: {} }) }
    end

    context 'invalid' do
      let(:input) { '' }

      it 'raises error' do
        expect { subject }.to raise_error(Fakeit::Validation::ValidationError, 'Invalid json payload')
      end
    end
  end

  context 'vendor defined json' do
    let(:content_type) { 'application/vnd.api+json' }

    context 'valid' do
      let(:input) { '{}' }

      it { is_expected.to eq({ media_type: 'application/vnd.api+json', data: {} }) }
    end

    context 'invalid' do
      let(:input) { '' }

      it 'raises error' do
        expect { subject }.to raise_error(Fakeit::Validation::ValidationError, 'Invalid json payload')
      end
    end
  end

  context 'multipart/form-data' do
    let(:content_type) { 'multipart/form-data, boundary=boundary' }
    let(:input) do
      <<~FORM_DATA
        --boundary\r
        content-disposition: form-data; name="id"\r
        \r
        123\r
        --boundary\r
        content-disposition: form-data; name="file"; filename="logo.jpg"\r
        Content-Type: image/jpeg\r
        Content-Transfer-Encoding: base64\r
        \r
        ABCD\r
        --boundary--\r
      FORM_DATA
    end

    it { is_expected.to eq({ media_type: 'multipart/form-data', data: { 'id' => '123', 'file' => 'ABCD' } }) }
  end

  context 'no body' do
    let(:content_type) { nil }
    let(:input) { nil }

    it { is_expected.to eq({ media_type: nil, data: '' }) }
  end
end
