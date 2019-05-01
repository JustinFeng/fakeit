describe Fakeit do
  include Rack::Test::Methods

  def app
    Fakeit.build('spec/fixtures/spec.json')
  end

  describe 'GET /' do
    it 'returns 200' do
      get '/'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      get '/'

      expect(JSON.parse(last_response.body)).to include('data' => a_kind_of(String))
    end

    it 'returns headers' do
      get '/'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'POST /' do
    it 'returns 201' do
      post '/'

      expect(last_response.created?).to be_truthy
    end

    it 'returns body' do
      post '/'

      expect(JSON.parse(last_response.body)).to include('id' => a_kind_of(Integer))
    end

    it 'returns headers' do
      post '/'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'PUT /' do
    it 'returns 200' do
      put '/'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body' do
      put '/'

      expect(JSON.parse(last_response.body)).to include('id' => a_kind_of(Integer))
    end

    it 'returns headers' do
      put '/'

      expect(last_response.headers).to include(
        'Content-Type' => 'application/json',
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end

  describe 'DELETE /' do
    it 'returns 200' do
      delete '/'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns headers' do
      delete '/'

      expect(last_response.headers).to include(
        'Correlation-Id' => a_kind_of(String)
      )
    end
  end
end
