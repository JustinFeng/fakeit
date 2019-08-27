describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('object_schema') }

  it 'object example' do
    expect(schema.to_example).to be_a_kind_of(Hash)
  end
end
