describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('number_schema')
  end

  it 'number example' do
    expect(schema.properties['number'].to_example).to be_a_kind_of(Float)
  end

  it 'range example' do
    expect(schema.properties['number_range'].to_example).to be_between(0, 10).inclusive
  end
end
