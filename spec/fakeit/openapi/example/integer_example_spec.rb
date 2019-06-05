describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('integer_schema')
  end

  it 'default integer example' do
    expect(Faker::Number).to receive(:between).with(1, Fakeit::Openapi::Example::BIG_INT).and_return(1)

    integer = schema.properties['integer']

    expect(integer.to_example).to be(1)
  end

  it 'range example' do
    expect(Faker::Number).to receive(:between).with(1, 10).and_return(1)

    integer_range = schema.properties['integer_range']

    expect(integer_range.to_example).to be(1)
  end

  it 'range exclusive example' do
    expect(Faker::Number).to receive(:between).with(2, 2).and_return(2)

    integer_range = schema.properties['integer_range_exclusive']

    expect(integer_range.to_example).to be(2)
  end

  it 'enum example' do
    integer_enum = schema.properties['integer_enum']

    expect(integer_enum.to_example).to eq(1).or eq(2)
  end
end
