describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('boolean_schema')
  end

  it 'boolean example' do
    boolean = schema.to_example(static: true)

    expect(boolean).to be(true)
  end
end
