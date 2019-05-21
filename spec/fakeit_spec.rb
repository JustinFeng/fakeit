describe Fakeit do
  include Rack::Test::Methods

  def app
    Fakeit.build('spec/fixtures/spec.json')
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

  describe 'invalid' do
    describe 'request body' do
      it 'returns 418' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        post '/invalid_request/123', '{"integer": "1"}'

        expect(JSON.parse(last_response.body)['message']).to include('not valid number')
      end
    end

    describe 'request path parameter' do
      it 'returns 418' do
        post '/invalid_request/abc'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        post '/invalid_request/abc'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        post '/invalid_request/abc'

        expect(JSON.parse(last_response.body)['message']).to include('not valid integer')
      end
    end

    describe 'request query parameter' do
      it 'returns 418' do
        post '/invalid_request/1?type=abc'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        post '/invalid_request/1?type=abc'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        post '/invalid_request/1?type=abc'

        expect(JSON.parse(last_response.body)['message']).to include('not valid boolean')
      end
    end

    describe 'request headers' do
      it 'returns 418' do
        header 'Api-Version', '1'
        post '/invalid_request/1'

        expect(last_response.status).to be(418)
      end

      it 'returns headers' do
        header 'Api-Version', '1'
        post '/invalid_request/1'

        expect(last_response.headers).to include('Content-Type' => 'application/json')
      end

      it 'returns validation error message' do
        header 'Api-Version', '1'
        post '/invalid_request/1'

        expect(JSON.parse(last_response.body)['message']).to include('isn\'t include enum')
      end
    end
  end
end
