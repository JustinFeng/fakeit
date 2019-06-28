describe Fakeit::Openapi::Schema do
  let(:schema) do
    load_schema('schema')
  end

  context 'random generates' do
    before(:each) do
      allow(Faker::Book).to receive(:title).and_return('string')
      allow(Faker::Number).to receive(:between).and_return(1)
      allow(Faker::Number).to receive(:between).and_return(1.0)
      allow(Faker::Boolean).to receive(:boolean).and_return(true)
    end

    it 'handles unknown type' do
      unknown = schema.items.properties['unknown']

      expect(unknown.to_example).to be_nil
    end

    it 'recursively examples' do
      example = schema.to_example

      expect(example.first).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 1.0,
        'boolean' => true
      )
    end

    it 'oneOf example' do
      one_of_example = schema.items.properties['one_of_example']
      allow(one_of_example.one_of).to receive(:sample).and_return(one_of_example.one_of.first)

      expect(one_of_example.to_example).to include(
        'integer' => 1,
        'number' => 1.0
      )
    end

    it 'allOf example' do
      all_of_example = schema.items.properties['all_of_example']

      expect(all_of_example.to_example).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 1.0,
        'boolean' => true
      )
    end

    it 'anyOf example' do
      any_of_example = schema.items.properties['any_of_example']
      allow(any_of_example.any_of).to receive_message_chain(:select, :sample).and_return(any_of_example.any_of)

      expect(any_of_example.to_example).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 1.0,
        'boolean' => true
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
