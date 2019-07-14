describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('array_schema')
  end

  it 'default array example' do
    array = schema.properties['array'].to_example(static: true)

    expect(array).to be_a_kind_of(Array)
    expect(array.size).to be(1)
  end

  it 'minItems and maxItems example' do
    array = schema.properties['array_min_max'].to_example(static: true)

    expect(array.size).to be(5)
  end
end
