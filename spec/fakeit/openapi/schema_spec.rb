describe Fakeit::Openapi::Schema do
  let(:schema) do
    load_schema('schema')
  end

  context 'when use example' do
    it 'honors specification example' do
      with_example = schema.items.properties['with_example']

      expect(with_example.to_example(use_example: true)).to eq('provided example')
    end

    it 'honors specification example recursively' do
      with_nested_example = schema.items.properties['with_nested_example']

      expect(with_nested_example.to_example(use_example: true)).to eq('with_example' => 'provided example')
    end

    it 'still generates example when not provided' do
      no_example = schema.items.properties['no_example']

      expect(no_example.to_example(use_example: true)).to eq('useful')
    end
  end

  context 'static' do
    it 'handles unknown type' do
      unknown = schema.items.properties['unknown']

      expect(unknown.to_example(static: true)).to be_nil
    end

    it 'recursively examples' do
      example = schema.to_example(static: true)

      expect(example.first).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 0.0,
        'boolean' => true
      )
    end

    it 'oneOf example' do
      one_of_example = schema.items.properties['one_of_example']

      expect(one_of_example.to_example(static: true)).to include(
        'integer' => 1,
        'number' => 0.0
      )
    end

    it 'allOf example' do
      all_of_example = schema.items.properties['all_of_example']

      expect(all_of_example.to_example(static: true)).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 0.0,
        'boolean' => true
      )
    end

    it 'anyOf example' do
      any_of_example = schema.items.properties['any_of_example']

      expect(any_of_example.to_example(static: true)).to include(
        'string' => 'string',
        'integer' => 1,
        'number' => 0.0,
        'boolean' => true
      )
    end
  end

  context 'random generates' do
    before(:each) do
      allow(Faker::Book).to receive(:title).and_return('random string')
      allow(Faker::Number).to receive(:between).and_return(2)
      allow(Faker::Number).to receive(:between).and_return(2.0)
      allow(Faker::Boolean).to receive(:boolean).and_return(false)
    end

    it 'handles unknown type' do
      unknown = schema.items.properties['unknown']

      expect(unknown.to_example).to be_nil
    end

    it 'recursively examples' do
      example = schema.to_example

      expect(example.first).to include(
        'string' => 'random string',
        'integer' => 2,
        'number' => 2.0,
        'boolean' => false
      )
    end

    it 'oneOf example' do
      one_of_example = schema.items.properties['one_of_example']

      expect(one_of_example.one_of).to receive(:sample).and_return(one_of_example.one_of.first)
      expect(one_of_example.to_example).to include(
        'integer' => 2,
        'number' => 2.0
      )
    end

    it 'allOf example' do
      all_of_example = schema.items.properties['all_of_example']

      expect(all_of_example.to_example).to include(
        'string' => 'random string',
        'integer' => 2,
        'number' => 2.0,
        'boolean' => false
      )
    end

    it 'anyOf example' do
      any_of_example = schema.items.properties['any_of_example']

      expect(any_of_example.any_of).to receive_message_chain(:select, :sample).and_return(any_of_example.any_of)
      expect(any_of_example.to_example).to include(
        'string' => 'random string',
        'integer' => 2,
        'number' => 2.0,
        'boolean' => false
      )
    end
  end
end
