describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('integer_schema')
  end

  it 'default integer example' do
    integer = schema.properties['integer']

    expect(integer.to_example(static: true)).to be(1)
  end

  it 'range example' do
    integer = schema.properties['integer_range']

    expect(integer.to_example(static: true)).to be(1)
  end

  it 'range exclusive example' do
    integer = schema.properties['integer_range_exclusive']

    expect(integer.to_example(static: true)).to be(2)
  end

  it 'enum example' do
    integer = schema.properties['integer_enum']

    expect(integer.to_example(static: true)).to eq(1)
  end

  it 'multiple example' do
    integer = schema.properties['integer_multiple']

    expect(integer.to_example(static: true)).to be(2)
  end
end
