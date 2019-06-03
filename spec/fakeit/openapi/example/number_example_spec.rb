describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('number_schema')
  end

  it 'number example' do
    expect(schema.to_example).to be_a_kind_of(Float)
  end
end
