describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('array_schema')
  end

  it 'array example' do
    expect(schema.to_example).to be_a_kind_of(Array)
  end
end
