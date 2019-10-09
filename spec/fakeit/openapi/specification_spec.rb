describe Fakeit::Openapi::Specification do
  let(:spec_file) { 'spec_file' }
  let(:mtime) { Time.new(2019, 1, 1, 0, 0, 1) }
  let(:new_mtime) { Time.new(2019, 1, 1, 0, 0, 2) }

  let(:doc) { double(OpenAPIParser::Schemas::OpenAPI) }
  let(:request_operation) { double(OpenAPIParser::RequestOperation) }
  let(:operation) { double(Fakeit::Openapi::Operation) }
  let(:options) { double(Fakeit::App::Options) }

  let(:method) { :get }
  let(:path) { '/' }

  before(:each) do
    allow(File).to receive(:exist?)
    allow(File).to receive(:mtime)
    allow(Fakeit::Openapi).to receive(:load).with(spec_file).and_return(doc)
  end

  it 'loads spec file' do
    expect(Fakeit::Openapi).to receive(:load).with(spec_file).and_return(doc)

    Fakeit::Openapi::Specification.new(spec_file)
  end

  describe 'operation' do
    subject { Fakeit::Openapi::Specification.new(spec_file) }

    before(:each) do
      allow(doc).to receive(:request_operation).with(method, path)
    end

    it 'gets matching operation' do
      allow(doc).to receive(:request_operation).with(method, path).and_return(request_operation)
      allow(Fakeit::Openapi::Operation).to receive(:new).with(request_operation, options).and_return(operation)

      expect(subject.operation(method, path, options)).to be(operation)
    end

    it 'returns nil when no matching operation' do
      allow(doc).to receive(:request_operation).with(method, path).and_return(nil)

      expect(subject.operation(method, path, options)).to be_nil
    end

    context 'local' do
      before(:each) do
        allow(File).to receive(:exist?).and_return(true)
        allow(File).to receive(:mtime).and_return(mtime, new_mtime)
      end

      it 'reloads doc if changed' do
        expect(Fakeit::Openapi).to receive(:load).twice.with(spec_file)

        subject.operation(method, path, options)
      end

      it 'does not reload spec if not changed' do
        allow(File).to receive(:mtime).and_return(mtime, mtime)

        expect(Fakeit::Openapi).to receive(:load).once.with(spec_file)

        subject.operation(method, path, options)
      end

      it 'handles invalid spec file' do
        call_count = 0
        allow(Fakeit::Openapi).to receive(:load).with(spec_file) do
          call_count += 1
          call_count == 1 ? doc : raise('not found')
        end

        expect(Fakeit::Logger).to receive(:warn).with(Rainbow('Invalid spec file, use previous snapshot instead').red)

        subject.operation(method, path, options)
      end
    end

    context 'remote' do
      before(:each) do
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:mtime).and_raise('not found')
      end

      it 'does not reload' do
        expect(Fakeit::Openapi).to receive(:load).once.with(spec_file)

        subject.operation(method, path, options)
      end
    end
  end
end
