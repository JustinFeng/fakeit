require 'fakeit'
require 'rack/test'

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

    it 'returns body OK' do
      get '/'

      expect(JSON.parse(last_response.body)).to include('data' => a_kind_of(String))
    end
  end
end
