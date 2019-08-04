describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('integer_schema')
  end

  context 'static' do
    it 'default integer example' do
      integer = schema.properties['integer']

      expect(integer.to_example(static: true)).to be(2**31 - 1)
    end

    it 'range example' do
      integer = schema.properties['integer_range']

      expect(integer.to_example(static: true)).to be(10)
    end

    it 'range exclusive example' do
      integer = schema.properties['integer_range_exclusive']

      expect(integer.to_example(static: true)).to be(2)
    end

    it 'enum example' do
      integer = schema.properties['integer_enum']

      expect(integer.to_example(static: true)).to eq(1)
    end

    it 'multiple example' do
      integer = schema.properties['integer_multiple']

      expect(integer.to_example(static: true)).to be(4)
    end
  end

  context 'random' do
    it 'default integer example' do
      expect(Faker::Number).to receive(:between).with(-2**31, 2**31 - 1).and_return(1)

      integer = schema.properties['integer']

      expect(integer.to_example).to be(1)
    end

    it 'range example' do
      expect(Faker::Number).to receive(:between).with(1, 10).and_return(1)

      integer = schema.properties['integer_range']

      expect(integer.to_example).to be(1)
    end

    it 'range exclusive example' do
      expect(Faker::Number).to receive(:between).with(2, 2).and_return(2)

      integer = schema.properties['integer_range_exclusive']

      expect(integer.to_example).to be(2)
    end

    it 'enum example' do
      integer = schema.properties['integer_enum']

      expect(integer.to_example).to eq(1).or eq(2)
    end

    it 'multiple example' do
      expect(Faker::Number).to receive(:between).with(1, 2).and_return(1)

      integer = schema.properties['integer_multiple']

      expect(integer.to_example).to be(2)
    end
  end
end
