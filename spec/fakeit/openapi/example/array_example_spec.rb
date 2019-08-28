describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('array_schema') }

  let(:use_static) { double('lambda', :[] => false) }
  let(:example_options) { { use_static: use_static, depth: 0, property: 'static_array' } }

  it 'calls use_static' do
    expect(use_static).to receive(:[]).with(type: 'array', property: 'static_array')

    schema.properties['array'].to_example(example_options)
  end

  context 'static' do
    let(:use_static) { double('lambda', :[] => true) }

    it 'default array example' do
      array = schema.properties['array'].to_example(example_options)

      expect(array).to be_a_kind_of(Array)
      expect(array.size).to be(1)
    end

    it 'minItems and maxItems example' do
      array = schema.properties['array_min_max'].to_example(example_options)

      expect(array.size).to be(5)
    end
  end

  context 'random' do
    it 'first level array example' do
      expect(Faker::Number).to receive(:between).with(from: 1, to: 10).and_return(3)

      array = schema.properties['array'].to_example(example_options)

      expect(array).to be_a_kind_of(Array)
      expect(array.size).to be(3)
    end

    it 'nested level array example' do
      expect(Faker::Number).to receive(:between).with(from: 1, to: 3).and_return(1)

      array = schema.properties['array'].to_example(example_options.merge(depth: 1))

      expect(array).to be_a_kind_of(Array)
      expect(array.size).to be(1)
    end

    it 'minItems and maxItems example' do
      expect(Faker::Number).to receive(:between).with(from: 5, to: 10).and_return(5)

      array = schema.properties['array_min_max'].to_example(example_options)

      expect(array.size).to be(5)
    end

    context 'uniqueItems' do
      it 'tries to generate minimum items to avoid duplication' do
        array = schema.properties['array_unique'].to_example(example_options)

        expect(array.size).to be(2)
      end

      it 'retries for unique results' do
        array_schema = schema.properties['array_unique']
        allow(array_schema.items).to receive(:to_example).and_return(1, 1, 2)

        array = array_schema.to_example(example_options)

        expect(array).to eq([1, 2])
      end

      it 'retries for double of the expected size at most' do
        array_schema = schema.properties['array_unique']
        allow(array_schema.items).to receive(:to_example).and_return(1, 1, 1, 1)

        array = array_schema.to_example(example_options)

        expect(array).to eq([1, 1])
      end
    end
  end
end
