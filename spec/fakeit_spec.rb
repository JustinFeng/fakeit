require 'fakeit'
require 'rack/test'

describe Fakeit do
  include Rack::Test::Methods

  def app
    Fakeit.build
  end

  describe 'GET /' do
    it 'returns 200' do
      get '/'

      expect(last_response.ok?).to be_truthy
    end

    it 'returns body OK' do
      get '/'

      expect(last_response.body).to eq('OK')
    end
  end
end
