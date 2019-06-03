describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('string_schema')
  end

  let(:pattern) { /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/ }

  it 'string example' do
    string = schema.properties['string']

    expect(string.to_example).to be_a_kind_of(String)
  end

  it 'pattern example' do
    string_pattern = schema.properties['string_pattern']

    expect(string_pattern.to_example).to be_a_kind_of(String).and match(pattern)
  end

  it 'enum example' do
    string_enum = schema.properties['string_enum']

    expect(string_enum.to_example).to eq('A').or eq('B')
  end

  it 'uri format example' do
    uri = schema.properties['string_uri'].to_example

    expect { URI.parse(uri) }.not_to raise_error
  end
end
