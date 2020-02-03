describe Fakeit::Middleware::Recorder do
  subject { Fakeit::Middleware::Recorder.new(app) }

  let(:response) { [200, {}, ['response body']] }
  let(:request_body) { StringIO.new('request body') }
  let(:app) { double('app', call: response) }
  let(:env) { { 'rack.input' => request_body } }

  before(:each) do
    allow(Fakeit::Logger).to receive(:info)
  end

  it 'returns original response' do
    status, headers, body = subject.call(env)

    expect(status).to be(200)
    expect(headers).to eq({})
    expect(body).to eq(['response body'])
  end

  it 'logs request body' do
    expect(Fakeit::Logger).to receive(:info).with(/Request body: request body/)

    subject.call(env)
  end

  it 'rewinds request body io' do
    subject.call(env)

    expect(request_body.read).to eq('request body')
  end

  context 'empty request body' do
    let(:request_body) { nil }

    it 'skips logging' do
      expect(Fakeit::Logger).not_to receive(:info).with(/Request body:.*/)

      subject.call(env)
    end
  end

  it 'logs response body' do
    expect(Fakeit::Logger).to receive(:info).with(/Response body: response body/)

    subject.call(env)
  end
end
