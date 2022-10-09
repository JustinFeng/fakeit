describe Fakeit::App::AppBuilder do
  subject { Fakeit::App::AppBuilder.new(spec_file, options).build }

  let(:spec_file) { 'spec_file' }
  let(:path_info) { '/' }
  let(:env) { Rack::MockRequest.env_for('', { 'PATH_INFO' => path_info }) }
  let(:base_path) { '/' }

  let(:options) { double(Fakeit::App::Options, base_path:) }
  let(:openapi_route) { double(Fakeit::App::Routes::OpenapiRoute) }
  let(:config_route) { double(Fakeit::App::Routes::ConfigRoute, options:) }

  before(:each) do
    allow(Fakeit::App::Routes::OpenapiRoute).to receive(:new).with(spec_file).and_return(openapi_route)
    allow(Fakeit::App::Routes::ConfigRoute).to receive(:new).with(options).and_return(config_route)
  end

  context 'with config path' do
    let(:path_info) { '/__fakeit_config__' }

    it 'delegates to config route' do
      expect(config_route).to receive(:call).with(Rack::Request)

      subject[env]
    end
  end

  context 'without base path override' do
    let(:path_info) { '/some-path' }

    it 'delegates to openapi route' do
      expect(openapi_route).to receive(:call).with(Rack::Request, options)

      subject[env]
    end
  end

  context 'with base path override' do
    let(:base_path) { '/api/' }

    context 'when path info contains base path' do
      let(:path_info) { '/api/sub-path' }

      it 'delegates to openapi route' do
        expect(openapi_route).to receive(:call) do |request, _options|
          expect(request.path_info).to eq('/sub-path')
        end

        subject[env]
      end
    end

    context 'when path info only misses trailing slash' do
      let(:path_info) { '/api' }

      it 'delegates to openapi route' do
        expect(openapi_route).to receive(:call) do |request, _options|
          expect(request.path_info).to eq('/')
        end

        subject[env]
      end
    end

    context 'when path info mismatches base path' do
      let(:path_info) { '/index' }

      it 'responds not found' do
        status, headers, body = subject[env]

        expect(status).to be(404)
        expect(headers).to eq({})
        expect(body).to eq(['Not Found'])
      end
    end
  end
end
