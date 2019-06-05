describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('array_schema')
  end

  it 'default array example' do
    expect(Faker::Number).to receive(:between).with(1, Fakeit::Openapi::Example::MAX_SIZE).and_return(1)

    array = schema.properties['array'].to_example

    expect(array).to be_a_kind_of(Array)
    expect(array.size).to be(1)
  end

  it 'array with minItems and maxItems example' do
    expect(Faker::Number).to receive(:between).with(5, 10).and_return(5)

    array = schema.properties['array_min_max'].to_example

    expect(array.size).to be(5)
  end
end
