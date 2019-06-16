describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('number_schema')
  end

  it 'default number example' do
    expect(Faker::Number).to receive(:between).with(0.0, Fakeit::Openapi::Example::BIG_NUM.to_f).and_return(1.0)

    number = schema.properties['number']

    expect(number.to_example).to be(1.0)
  end

  it 'range example' do
    expect(Faker::Number).to receive(:between).with(5.0, 10.0).and_return(5.1)

    number = schema.properties['number_range']

    expect(number.to_example).to be(5.1)
  end
end