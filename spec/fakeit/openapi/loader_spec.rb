describe Fakeit::Openapi do
  let(:content) { 'string' }
  let(:data) { 'hash' }
  let(:doc) { 'openapi_doc' }

  before(:each) do
    allow(OpenAPIParser).to receive(:parse).with(data).and_return(doc)
  end

  describe 'json' do
    let(:json_file) { 'spec.json' }

    it 'loads spec file' do
      expect(Fakeit::Openapi).to receive(:open).with(json_file).and_return(content)
      expect(JSON).to receive(:parse).with(content).and_return(data)
      expect(Fakeit::Openapi.load(json_file)).to be(doc)
    end
  end

  describe 'yml' do
    let(:yml_file) { 'spec.yml' }

    it 'loads spec file' do
      expect(Fakeit::Openapi).to receive(:open).with(yml_file).and_return(content)
      expect(YAML).to receive(:safe_load).with(content).and_return(data)
      expect(Fakeit::Openapi.load(yml_file)).to be(doc)
    end
  end

  describe 'yaml' do
    let(:yml_file) { 'spec.yaml' }

    it 'loads spec file' do
      expect(Fakeit::Openapi).to receive(:open).with(yml_file).and_return(content)
      expect(YAML).to receive(:safe_load).with(content).and_return(data)
      expect(Fakeit::Openapi.load(yml_file)).to be(doc)
    end
  end

  it 'raises error for other file type' do
    expect { Fakeit::Openapi.load('blah') }.to raise_error('Invalid openapi specification file')
  end
end
