describe Fakeit::App::Helpers::BodyParser do
  let(:request) do
    Rack::Request.new(Rack::MockRequest.env_for('', { 'CONTENT_TYPE' => content_type, input: input }))
  end

  subject { Fakeit::App::Helpers::BodyParser.parse(request) }

  %w[application/json application/vnd.api+json].each do |media_type|
    context media_type do
      let(:content_type) { media_type }

      context 'valid' do
        let(:input) { '{"a":1}' }

        it { is_expected.to eq({ media_type: media_type, data: { 'a' => 1 } }) }
      end

      context 'empty body' do
        let(:input) { nil }

        it { is_expected.to eq({ media_type: media_type, data: {} }) }
      end

      context 'invalid' do
        let(:input) { '{' }

        it 'raises error' do
          expect { subject }.to raise_error(Fakeit::Validation::ValidationError, 'Invalid json payload')
        end
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
