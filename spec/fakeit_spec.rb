describe Fakeit do
  include Rack::Test::Methods

  let(:options) { Fakeit::App::Options.new(permissive: false) }

  def app
    Fakeit.build('spec/fixtures/spec.json', options)
  end

  describe 'GET /resource/{id}' do
    it 'returns 200' do
      get '/resource/1'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      get '/resource/1'

      expect(JSON.parse(last_response.body)).to include('data' => a_kind_of(String))
    end

    it 'returns headers' do
      get '/resource/1'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'POST /resource/{id}' do
    it 'returns 201' do
      post '/resource/1'

      expect(last_response.created?).to be_truthy
    end

    it 'returns body' do
      post '/resource/1'

      expect(JSON.parse(last_response.body)).to include('id' => a_kind_of(Integer))
    end

    it 'returns headers' do
      post '/resource/1'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'PUT /resource/{id}' do
    it 'returns 200' do
      put '/resource/1'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      put '/resource/1'

      expect(JSON.parse(last_response.body)).to include('id' => a_kind_of(Integer))
    end

    it 'returns headers' do
      put '/resource/1'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'DELETE /resource/{id}' do
    it 'returns 200' do
      delete '/resource/1'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns headers' do
      delete '/resource/1'

      expect(last_response.headers).to include(
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'non json request content type' do
    it 'returns 200' do
      header 'CONTENT_TYPE', 'text/plain'
      post '/non_json', 'text plain'

      expect(last_response.ok?).to be_truthy
    end
  end

  describe 'invalid request' do
    describe 'request body' do
      it 'returns 418' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/123', '{"integer": "1"}'

        expect(JSON.parse(last_response.body)['message']).to include('expected number')
      end
    end

    describe 'request path parameter' do
      it 'returns 418' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/abc', '{"integer": 1}'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/abc', '{"integer": 1}'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/abc', '{"integer": 1}'

        expect(JSON.parse(last_response.body)['message']).to include('expected integer')
      end
    end

    describe 'request query parameter' do
      it 'returns 418' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1?type=abc', '{"integer": 1}'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1?type=abc', '{"integer": 1}'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1?type=abc', '{"integer": 1}'

        expect(JSON.parse(last_response.body)['message']).to include('expected boolean')
      end
    end

    describe 'request headers' do
      it 'returns 418' do
        header 'Api-Version', '1'
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1', '{"integer": 1}'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        header 'Api-Version', '1'
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1', '{"integer": 1}'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        header 'Api-Version', '1'
        header 'CONTENT_TYPE', 'application/json'
        post '/invalid_request/1', '{"integer": 1}'

        expect(JSON.parse(last_response.body)['message']).to include('isn\'t part of the enum')
      end
    end

    context 'permissive mode' do
      let(:options) { Fakeit::App::Options.new(permissive: true) }

      it 'returns 201' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.created?).to be_truthy
      end

      it 'returns headers' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.headers).to include(
          'Content-Type' => 'application/json',
          'Correlation-Id' => a_kind_of(String)
        )
      end

      it 'returns validation error message' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(JSON.parse(last_response.body)).to include('id' => a_kind_of(Integer))
      end
    end
  end

  describe 'GET /__fakeit_config__' do
    it 'returns 200' do
      get '/__fakeit_config__'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      get '/__fakeit_config__'

      expect(JSON.parse(last_response.body)).to eq(
        'permissive' => false,
        'use_example' => false,
        'static' => false,
        'static_types' => [],
        'static_properties' => [],
        'base_path' => '/'
      )
    end

    it 'returns headers' do
      get '/__fakeit_config__'

      expect(last_response.headers).to eq('Content-Type' => 'application/json')
    end
  end

  describe 'PUT /__fakeit_config__' do
    let(:config) do
      {
        'permissive' => true,
        'use_example' => true,
        'static' => true,
        'static_types' => ['string'],
        'static_properties' => ['id'],
        'base_path' => '/'
      }
    end

    it 'returns 200' do
      header 'CONTENT_TYPE', 'application/json'
      put '/__fakeit_config__', config.to_json

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      header 'CONTENT_TYPE', 'application/json'
      put '/__fakeit_config__', config.to_json

      expect(JSON.parse(last_response.body)).to eq(config)
    end

    it 'returns headers' do
      header 'CONTENT_TYPE', 'application/json'
      put '/__fakeit_config__', config.to_json

      expect(last_response.headers).to eq('Content-Type' => 'application/json')
    end
  end
end
