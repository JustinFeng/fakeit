describe Fakeit::Middleware::Logger do
  subject { Fakeit::Middleware::Logger.new(app) }

  let(:response) { [200, {}, ['response body']] }
  let(:request_body) { StringIO.new('request body') }
  let(:app) { double('app', call: response) }
  let(:env) { { 'rack.input' => request_body } }

  it 'returns original response' do
    status, headers, body = subject.call(env)

    expect(status).to be(200)
    expect(headers).to eq({})
    expect(body).to eq(['response body'])
  end

  it 'logs request body' do
    expect { subject.call(env) }.to output(/Request body: request body/).to_stdout
  end

  it 'rewinds request body io' do
    subject.call(env)

    expect(request_body.read).to eq('request body')
  end

  it 'logs response body' do
    expect { subject.call(env) }.to output(/Response body: response body/).to_stdout
  end
end
