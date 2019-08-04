describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('number_schema')
  end

  context 'static' do
    it 'default number example' do
      number = schema.properties['number']

      expect(number.to_example(static: true)).to be((2**31 - 1).to_f)
    end

    it 'range example' do
      number = schema.properties['number_range']

      expect(number.to_example(static: true)).to be(10.0)
    end

    it 'multiple by example' do
      number = schema.properties['number_multiple']

      expect(number.to_example(static: true)).to be(6.375)
    end
  end

  context 'random' do
    it 'default number example' do
      expect(Faker::Number).to receive(:between).with(-2**31, 2**31 - 1).and_return(1.123)

      number = schema.properties['number']

      expect(number.to_example).to be(1.12)
    end

    it 'range example' do
      expect(Faker::Number).to receive(:between).with(5.0, 10.0).and_return(5.1)

      number = schema.properties['number_range']

      expect(number.to_example).to be(5.1)
    end

    it 'multiple by example' do
      expect(Faker::Number).to receive(:between).with(1, 3).and_return(3)

      number = schema.properties['number_multiple']

      expect(number.to_example).to be(6.375)
    end
  end
end
