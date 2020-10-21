describe Fakeit::App::Routes::OpenapiRoute do
  subject { Fakeit::App::Routes::OpenapiRoute.new(spec_file) }

  let(:options) { Fakeit::App::Options.new(permissive: false) }
  let(:spec_file) { 'spec_file' }
  let(:specification) { double(Fakeit::Openapi::Specification) }
  let(:env) do
    {
      'REQUEST_METHOD' => 'GET',
      'PATH_INFO' => '/',
      'rack.input' => StringIO.new('body'),
      'QUERY_STRING' => 'q=a',
      'HTTP_SOME_HEADER' => 'header'
    }
  end
  let(:request) { Rack::Request.new(env) }

  before(:each) do
    allow(Fakeit::Openapi::Specification).to receive(:new).with(spec_file).and_return(specification)
  end

  it 'handles valid request' do
    operation_headers = { 'Content-Type' => 'application' }
    operation = double(Fakeit::Openapi::Operation, status: 200, headers: operation_headers, body: 'body', validate: nil)
    allow(specification).to receive(:operation).with(:get, '/', options).and_return(operation)

    status, headers, body = subject.call(request, options)

    expect(status).to be(200)
    expect(headers).to eq(operation_headers)
    expect(body).to eq(['body'])
  end

  it 'handles not found' do
    allow(specification).to receive(:operation).with(:get, '/not_found', options).and_return(nil)
    request = Rack::Request.new({ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/not_found' })

    status, headers, body = subject.call(request, options)

    expect(status).to be(404)
    expect(headers).to eq({})
    expect(body).to eq(['Not Found'])
  end

  describe 'validation' do
    let(:operation) { double(Fakeit::Openapi::Operation, status: 200, headers: {}, body: 'body') }

    before(:each) do
      allow(specification).to receive(:operation).with(:get, '/', options).and_return(operation)
    end

    context 'validates request' do
      it 'passes request headers' do
        expect(operation).to receive(:validate).with(hash_including(headers: { 'Some-Header' => 'header' }))

        subject.call(request, options)
      end

      context 'params' do
        it 'passes single value param' do
          expect(operation).to receive(:validate).with(hash_including(params: { 'q' => 'a' }))

          subject.call(request, options)
        end

        it 'passes array value param with [] postfix' do
          expect(operation).to receive(:validate).with(hash_including(params: { 'q' => %w[a b] }))

          subject.call(Rack::Request.new(env.merge('QUERY_STRING' => 'q[]=a&q[]=b')), options)
        end

        it 'passes array value param without [] postfix' do
          expect(operation).to receive(:validate).with(hash_including(params: { 'q' => %w[a b] }))

          subject.call(Rack::Request.new(env.merge('QUERY_STRING' => 'q=a&q=b')), options)
        end
      end

      context 'body' do
        let(:parsed_body) { {} }

        before(:each) do
          allow(Fakeit::App::Helpers::BodyParser).to receive(:parse).and_return(parsed_body)
        end

        it 'passes parsed request body' do
          expect(operation).to receive(:validate).with(hash_including(body: parsed_body))

          subject.call(request, options)
        end
      end
    end

    context 'failed' do
      before(:each) do
        allow(operation).to receive(:validate).and_raise(Fakeit::Validation::ValidationError, 'some error')
      end

      it 'fails invalid request' do
        status, headers, body = subject.call(request, options)

        expect(status).to be(418)
        expect(headers).to eq('Content-Type' => 'application/json')
        expect(body).to eq(['{"message":"some error"}'])
      end

      context 'body parse failed' do
        before(:each) do
          allow(Fakeit::App::Helpers::BodyParser)
            .to receive(:parse).and_raise(Fakeit::Validation::ValidationError, 'some error')
        end

        it 'fails invalid request' do
          status, headers, body = subject.call(request, options)

          expect(status).to be(418)
          expect(headers).to eq('Content-Type' => 'application/json')
          expect(body).to eq(['{"message":"some error"}'])
        end
      end

      context 'permissive mode' do
        let(:options) { Fakeit::App::Options.new(permissive: true) }

        before(:each) do
          allow(Fakeit::Logger).to receive(:warn)
        end

        it 'responds normally' do
          status, headers, body = subject.call(request, options)

          expect(status).to be(200)
          expect(headers).to eq({})
          expect(body).to eq(['body'])
        end

        it 'warns validation error' do
          expect(Fakeit::Logger).to receive(:warn).with(Rainbow('some error').red)

          subject.call(request, options)
        end
      end
    end
  end
end
