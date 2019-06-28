describe Fakeit::Openapi::Schema do
  let(:schema) do
    load_schema('schema')
  end

  context 'random generates' do
    it 'handles unknown type' do
      unknown = schema.items.properties['unknown']

      expect(unknown.to_example).to be_nil
    end

    it 'recursively examples' do
      example = schema.to_example

      expect(example.first).to include(
        'string' => a_kind_of(String),
        'integer' => a_kind_of(Integer),
        'number' => a_kind_of(Float),
        'boolean' => a_kind_of(TrueClass).or(be_a_kind_of(FalseClass))
      )
    end

    it 'oneOf example' do
      one_of_example = schema.items.properties['one_of_example']

      expect(one_of_example.to_example).to include(
        'integer' => a_kind_of(Integer),
        'number' => a_kind_of(Float)
      ).or include(
        'string' => a_kind_of(String),
        'boolean' => a_kind_of(TrueClass).or(be_a_kind_of(FalseClass))
      )
    end
  end

  context 'when use example' do
    it 'honors specification example' do
      with_example = schema.items.properties['with_example']

      expect(with_example.to_example(use_example: true)).to eq('always fixed')
    end

    it 'honors specification example recursively' do
      with_nested_example = schema.items.properties['with_nested_example']

      expect(with_nested_example.to_example(use_example: true)).to eq('with_example' => 'always fixed')
    end

    it 'still generates example when not provided' do
      no_example = schema.items.properties['no_example']

      expect(no_example.to_example(use_example: true)).to eq('useful')
    end
  end
end
