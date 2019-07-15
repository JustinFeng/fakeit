describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('number_schema')
  end

  it 'default number example' do
    number = schema.properties['number']

    expect(number.to_example(static: true)).to be(0.0)
  end

  it 'range example' do
    number = schema.properties['number_range']

    expect(number.to_example(static: true)).to be(5.0)
  end

  it 'multiple by example' do
    number = schema.properties['number_multiple']

    expect(number.to_example(static: true)).to be(2.125)
  end
end
