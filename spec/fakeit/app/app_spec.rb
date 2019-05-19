describe Fakeit::App do
  subject { Fakeit::App.create(spec_file) }

  let(:spec_file) { 'spec_file' }
  let(:specification) { double(Fakeit::Openapi::Specification) }

  before(:each) do
    allow(Fakeit::Openapi).to receive(:load).with(spec_file).and_return(specification)
  end

  it 'handles valid request' do
    operation = double(Fakeit::Openapi::Operation, status: 200, headers: {}, body: 'body')
    allow(specification).to receive(:operation).with(:get, '/').and_return(operation)
    allow(operation).to receive(:validate)

    status, headers, body = subject[{ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/' }]

    expect(status).to be(200)
    expect(headers).to eq({})
    expect(body).to eq(['body'])
  end

  it 'handles not found' do
    allow(specification).to receive(:operation).with(:get, '/not_found').and_return(nil)

    status, headers, body = subject[{ 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/not_found' }]

    expect(status).to be(404)
    expect(headers).to eq({})
    expect(body).to eq(['Not Found'])
  end

  it 'handles invalid request' do
    operation = double(Fakeit::Openapi::Operation)

    allow(operation).to receive(:validate).and_raise(Fakeit::Validation::ValidationError, 'some error')
    allow(specification).to receive(:operation).with(:get, '/').and_return(operation)

    status, headers, body = subject[{
      'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/', 'rack.input' => StringIO.new('body')
    }]

    expect(status).to be(418)
    expect(headers).to eq('Content-Type' => 'application/json')
    expect(body).to eq(['{"message":"some error"}'])
  end
end
