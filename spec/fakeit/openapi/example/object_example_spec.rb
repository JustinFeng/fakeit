describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('object_schema')
  end

  it 'object example' do
    expect(schema.to_example).to be_a_kind_of(Hash)
  end
end
