describe Fakeit::App::AppBuilder do
  subject { Fakeit::App::AppBuilder.new(spec_file, options).build }

  let(:spec_file) { 'spec_file' }
  let(:env) { 'env' }
  let(:request) { double(Rack::Request) }
  let(:base_path) { '/' }

  let(:options) { double(Fakeit::App::Options, base_path: base_path) }
  let(:openapi_route) { double(Fakeit::App::Routes::OpenapiRoute) }
  let(:config_route) { double(Fakeit::App::Routes::ConfigRoute, options: options) }

  before(:each) do
    allow(Rack::Request).to receive(:new).with(env).and_return(request)
    allow(Fakeit::App::Routes::OpenapiRoute).to receive(:new).with(spec_file).and_return(openapi_route)
    allow(Fakeit::App::Routes::ConfigRoute).to receive(:new).with(options).and_return(config_route)
  end

  it 'handles config route' do
    allow(request).to receive(:path_info).and_return('/__fakeit_config__')

    expect(config_route).to receive(:call).with(request)

    subject[env]
  end

  it 'handles openapi route' do
    allow(request).to receive(:path_info).and_return('/other')
    allow(request).to receive(:path_info=).with('/other')

    expect(openapi_route).to receive(:call).with(request, options)

    subject[env]
  end

  context 'when base_path is not the root' do
    let(:base_path) { '/some_base_path/' }

    it 'handles openapi route' do
      allow(request).to receive(:path_info).and_return('/some_base_path/other')

      expect(request).to receive(:path_info=).with('/other')
      expect(openapi_route).to receive(:call).with(request, options)

      subject[env]
    end
  end
end
