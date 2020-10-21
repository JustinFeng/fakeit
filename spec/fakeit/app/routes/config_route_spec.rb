describe Fakeit::App::Routes::ConfigRoute do
  subject { Fakeit::App::Routes::ConfigRoute.new(options) }

  let(:options) { double(Fakeit::App::Options, to_hash: { some: 'config' }) }
  let(:env) { { 'REQUEST_METHOD' => method } }
  let(:request) { Rack::Request.new(env) }

  context 'GET' do
    let(:method) { 'GET' }
    let(:body) { nil }

    it 'returns current config' do
      status, headers, body = subject.call(request)

      expect(status).to be(200)
      expect(headers).to eq(Fakeit::App::Routes::ConfigRoute::HEADERS)
      expect(body).to eq('{"some":"config"}')
    end
  end

  context 'PUT' do
    let(:method) { 'PUT' }
    let(:config) do
      {
        permissive: true,
        use_example: true,
        static: true,
        static_types: ['string'],
        static_properties: ['id']
      }
    end

    before(:each) { allow(Fakeit::App::Helpers::BodyParser).to receive(:parse).with(request).and_return(config) }

    it 'update config' do
      subject.call(request)

      expect(subject.options.to_hash).to eq(config)
    end

    it 'returns updated config' do
      status, headers, body = subject.call(request)

      expect(status).to be(200)
      expect(headers).to eq(Fakeit::App::Routes::ConfigRoute::HEADERS)
      expect(body).to eq(config.to_json)
    end

    context 'invalid config' do
      let(:config) { { unknown: 'value' } }

      it 'returns error response' do
        status, headers, body = subject.call(request)

        expect(status).to be(422)
        expect(headers).to eq(Fakeit::App::Routes::ConfigRoute::HEADERS)
        expect(body).to eq(['{"message":"unknown keyword: :unknown"}'])
      end
    end
  end

  context 'Not allowed' do
    let(:method) { 'PATCH' }

    it 'returns not allowed' do
      status, headers, body = subject.call(request)

      expect(status).to be(405)
      expect(headers).to eq({})
      expect(body).to eq(['Method Not Allowed'])
    end
  end
end
