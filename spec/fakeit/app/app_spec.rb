describe Fakeit::App do
  subject { Fakeit::App.create(spec_file, options) }

  let(:options) { Fakeit::App::Options.new(permissive: false) }
  let(:spec_file) { 'spec_file' }
  let(:specification) { double(Fakeit::Openapi::Specification) }
  let(:env) do
    {
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/',
      'rack.input' => StringIO.new('body'),
      'rack.request.query_hash' => {},
      'HTTP_SOME_HEADER' => 'header'
    }
  end

  before(:each) do
    allow(Fakeit::Openapi).to receive(:load).with(spec_file).and_return(specification)
  end

  it 'handles valid request' do
    headers = { 'Content-Type' => 'application' }
    operation = double(Fakeit::Openapi::Operation, status: 200, headers: headers, body: 'body', validate: nil)
    allow(specification).to receive(:operation).with(:get, '/', options).and_return(operation)

    status, headers, body = subject[env]

    expect(status).to be(200)
    expect(headers).to eq(headers)
    expect(body).to eq(['body'])
  end

  it 'handles not found' do
    allow(specification).to receive(:operation).with(:get, '/not_found', options).and_return(nil)

    status, headers, body = subject[{ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/not_found' }]

    expect(status).to be(404)
    expect(headers).to eq({})
    expect(body).to eq(['Not Found'])
  end

  describe 'validation' do
    let(:operation) { double(Fakeit::Openapi::Operation, status: 200, headers: headers, body: 'body') }
    let(:headers) { { 'Some-Header' => 'header' } }

    before(:each) do
      allow(specification).to receive(:operation).with(:get, '/', options).and_return(operation)
      allow(operation).to receive(:validate).and_raise(Fakeit::Validation::ValidationError, 'some error')
    end

    it 'validates request' do
      expect(operation).to receive(:validate).with(body: 'body', params: {}, headers: headers)

      subject[env]
    end

    it 'fails invalid request by default' do
      status, headers, body = subject[env]

      expect(status).to be(418)
      expect(headers).to eq('Content-Type' => 'application/json')
      expect(body).to eq(['{"message":"some error"}'])
    end

    context 'permissive mode' do
      let(:options) { Fakeit::App::Options.new(permissive: true) }

      before(:each) do
        allow(Fakeit::Logger).to receive(:warn)
      end

      it 'responds normally' do
        status, headers, body = subject[env]

        expect(status).to be(200)
        expect(headers).to eq(headers)
        expect(body).to eq(['body'])
      end

      it 'warns validation error' do
        expect(Fakeit::Logger).to receive(:warn).with('some error')

        subject[env]
      end
    end
  end

  context 'allow cors' do
    let(:options) { Fakeit::App::Options.new(allow_cors: true) }

    it 'handles valid request' do
      headers = { 'Content-Type' => 'application' }
      headers_spec = { 'Content-Type' => 'application', 'Access-Control-Allow-Origin' => '*' }
      operation = double(Fakeit::Openapi::Operation, status: 200, headers: headers, body: 'body', validate: nil)
      allow(specification).to receive(:operation).with(:get, '/', options).and_return(operation)

      status, headers, body = subject[env]

      expect(status).to be(200)
      expect(headers).to eq(headers_spec)
      expect(body).to eq(['body'])
    end

    it 'handles not found' do
      allow(specification).to receive(:operation).with(:get, '/not_found', options).and_return(nil)

      status, headers, body = subject[{ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/not_found' }]

      expect(status).to be(404)
      expect(headers).to eq('Access-Control-Allow-Origin' => '*')
      expect(body).to eq(['Not Found'])
    end
  end
end
