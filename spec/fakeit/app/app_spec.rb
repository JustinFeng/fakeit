describe Fakeit::App do
  subject { Fakeit::App.create(spec_file, options) }

  let(:options) { 'options' }
  let(:spec_file) { 'spec_file' }
  let(:env) { 'env' }
  let(:request) { 'request' }
  let(:openapi_route) { double(Fakeit::App::Routes::OpenapiRoute) }

  before(:each) do
    allow(Rack::Request).to receive(:new).with(env).and_return(request)
    allow(Fakeit::App::Routes::OpenapiRoute).to receive(:new).with(spec_file).and_return(openapi_route)
  end

  it 'handles openapi route' do
    expect(openapi_route).to receive(:call).with(request, options)

    subject[env]
  end
end
