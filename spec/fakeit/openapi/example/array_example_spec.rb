describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('array_schema')
  end

  it 'array example' do
    expect(schema.properties['array'].to_example).to be_a_kind_of(Array)
  end

  it 'array item number example' do
    expect(schema.properties['array_item_number'].to_example.size).to be_between(5, 10).inclusive
  end
end
