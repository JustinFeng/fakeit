describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('boolean_schema')
  end

  context 'static' do
    let(:example_options) { { use_static: proc { true } } }

    it 'boolean example' do
      boolean = schema.to_example(example_options)

      expect(boolean).to be(true)
    end
  end

  context 'random' do
    let(:example_options) { { use_static: proc { false } } }

    it 'boolean example' do
      expect(Faker::Boolean).to receive(:boolean).and_return(true)

      boolean = schema.to_example(example_options)

      expect(boolean).to be(true)
    end
  end
end
