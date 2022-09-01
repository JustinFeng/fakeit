describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('integer_schema') }

  let(:use_static) { double('lambda', :[] => false) }
  let(:example_options) { { use_static:, property: 'static_integer' } }

  it 'calls use_static' do
    expect(use_static).to receive(:[]).with(type: 'integer', property: 'static_integer')

    schema.properties['integer'].to_example(example_options)
  end

  context 'static' do
    let(:use_static) { double('lambda', :[] => true) }

    it 'default integer example' do
      integer = schema.properties['integer']

      expect(integer.to_example(example_options)).to eq((2**31) - 1)
    end

    it 'int32 integer example' do
      integer = schema.properties['integer_int32']

      expect(integer.to_example(example_options)).to eq((2**31) - 1)
    end

    it 'int64 integer example' do
      integer = schema.properties['integer_int64']

      expect(integer.to_example(example_options)).to eq((2**63) - 1)
    end

    it 'handles unknown format' do
      integer = schema.properties['integer_unknown']

      expect(integer.to_example(example_options)).to eq((2**31) - 1)
    end

    it 'range example' do
      integer = schema.properties['integer_range']

      expect(integer.to_example(example_options)).to eq(10)
    end

    it 'range exclusive example' do
      integer = schema.properties['integer_range_exclusive']

      expect(integer.to_example(example_options)).to eq(2)
    end

    it 'enum example' do
      integer = schema.properties['integer_enum']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'multiple example' do
      integer = schema.properties['integer_multiple']

      expect(integer.to_example(example_options)).to eq(4)
    end
  end

  context 'random' do
    it 'default integer example' do
      expect(Faker::Number).to receive(:between).with(from: -2**31, to: (2**31) - 1).and_return(1)

      integer = schema.properties['integer']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'int32 integer example' do
      expect(Faker::Number).to receive(:between).with(from: -2**31, to: (2**31) - 1).and_return(1)

      integer = schema.properties['integer_int32']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'int64 integer example' do
      expect(Faker::Number).to receive(:between).with(from: -2**63, to: (2**63) - 1).and_return(1)

      integer = schema.properties['integer_int64']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'handles unknown format' do
      expect(Faker::Number).to receive(:between).with(from: -2**31, to: (2**31) - 1).and_return(1)

      integer = schema.properties['integer_unknown']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'range example' do
      expect(Faker::Number).to receive(:between).with(from: 1, to: 10).and_return(1)

      integer = schema.properties['integer_range']

      expect(integer.to_example(example_options)).to eq(1)
    end

    it 'range exclusive example' do
      expect(Faker::Number).to receive(:between).with(from: 2, to: 2).and_return(2)

      integer = schema.properties['integer_range_exclusive']

      expect(integer.to_example(example_options)).to eq(2)
    end

    it 'enum example' do
      integer = schema.properties['integer_enum']

      expect(integer.to_example(example_options)).to eq(1).or eq(2)
    end

    it 'multiple example' do
      expect(Faker::Number).to receive(:between).with(from: 1, to: 2).and_return(1)

      integer = schema.properties['integer_multiple']

      expect(integer.to_example(example_options)).to eq(2)
    end
  end
end
