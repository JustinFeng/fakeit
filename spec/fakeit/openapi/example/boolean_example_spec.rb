describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('boolean_schema')
  end

  context 'static' do
    it 'boolean example' do
      boolean = schema.to_example(static: true)

      expect(boolean).to be(true)
    end
  end

  context 'random' do
    it 'boolean example' do
      expect(Faker::Boolean).to receive(:boolean).and_return(true)

      boolean = schema.to_example

      expect(boolean).to be(true)
    end
  end
end
