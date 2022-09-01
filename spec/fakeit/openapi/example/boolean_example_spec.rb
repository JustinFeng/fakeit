describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('boolean_schema') }

  let(:use_static) { double('lambda', :[] => false) }
  let(:example_options) { { use_static:, property: 'static_boolean' } }

  it 'calls use_static' do
    expect(use_static).to receive(:[]).with(type: 'boolean', property: 'static_boolean')

    schema.to_example(example_options)
  end

  context 'static' do
    let(:use_static) { double('lambda', :[] => true) }

    it 'boolean example' do
      boolean = schema.to_example(example_options)

      expect(boolean).to be(true)
    end
  end

  context 'random' do
    it 'boolean example' do
      expect(Faker::Boolean).to receive(:boolean).and_return(true)

      boolean = schema.to_example(example_options)

      expect(boolean).to be(true)
    end
  end
end
