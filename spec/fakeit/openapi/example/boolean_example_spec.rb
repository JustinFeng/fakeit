describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('boolean_schema')
  end

  it 'boolean example' do
    expect(schema.to_example).to be_a_kind_of(TrueClass).or be_a_kind_of(FalseClass)
  end
end
