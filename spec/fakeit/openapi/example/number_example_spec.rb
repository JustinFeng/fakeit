describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('number_schema') }

  let(:use_static) { double('lambda', :[] => false) }
  let(:example_options) { { use_static: use_static, property: 'static_number' } }

  it 'calls use_static' do
    expect(use_static).to receive(:[]).with(type: 'number', property: 'static_number')

    schema.properties['number'].to_example(example_options)
  end

  context 'static' do
    let(:use_static) { double('lambda', :[] => true) }

    it 'default number example' do
      number = schema.properties['number']

      expect(number.to_example(example_options)).to be((2**31 - 1).to_f)
    end

    it 'range example' do
      number = schema.properties['number_range']

      expect(number.to_example(example_options)).to be(10.0)
    end

    it 'multiple by example' do
      number = schema.properties['number_multiple']

      expect(number.to_example(example_options)).to be(6.375)
    end
  end

  context 'random' do
    it 'default number example' do
      expect(Faker::Number).to receive(:between).with(from: -2**31, to: 2**31 - 1).and_return(1.123)

      number = schema.properties['number']

      expect(number.to_example(example_options)).to be(1.12)
    end

    it 'range example' do
      expect(Faker::Number).to receive(:between).with(from: 5.0, to: 10.0).and_return(5.1)

      number = schema.properties['number_range']

      expect(number.to_example(example_options)).to be(5.1)
    end

    it 'multiple by example' do
      expect(Faker::Number).to receive(:between).with(from: 1, to: 3).and_return(3)

      number = schema.properties['number_multiple']

      expect(number.to_example(example_options)).to be(6.375)
    end
  end
end
