describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('integer_schema')
  end

  it 'integer example' do
    integer = schema.properties['integer']

    expect(integer.to_example).to be_a_kind_of(Integer)
  end

  it 'range example' do
    integer_range = schema.properties['integer_range']

    expect(integer_range.to_example).to be(1)
  end

  it 'enum example' do
    integer_enum = schema.properties['integer_enum']

    expect(integer_enum.to_example).to eq(1).or eq(2)
  end
end
