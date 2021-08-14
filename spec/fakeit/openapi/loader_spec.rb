describe Fakeit::Openapi do
  let(:content) { 'string' }
  let(:data) { 'hash' }
  let(:doc) { 'openapi_doc' }

  before(:each) do
    allow(URI).to receive(:open).and_return(content)
    allow(OpenAPIParser).to receive(:parse).with(data).and_return(doc)
  end

  describe 'json' do
    let(:src) { 'spec.json' }

    it 'loads spec file' do
      expect(JSON).to receive(:parse).with(content).and_return(data)
      expect(Fakeit::Openapi.load(src)).to be(doc)
    end
  end

  describe 'yml' do
    let(:src) { 'spec.yml' }

    it 'loads spec file' do
      expect(YAML).to receive(:safe_load).with(content, [Date, Time]).and_return(data)
      expect(Fakeit::Openapi.load(src)).to be(doc)
    end
  end

  describe 'yaml' do
    let(:src) { 'spec.yaml' }

    it 'loads spec file' do
      expect(YAML).to receive(:safe_load).with(content, [Date, Time]).and_return(data)
      expect(Fakeit::Openapi.load(src)).to be(doc)
    end
  end

  it 'raises error for other file type' do
    expect { Fakeit::Openapi.load('blah') }.to raise_error('Invalid openapi specification file')
  end
end
