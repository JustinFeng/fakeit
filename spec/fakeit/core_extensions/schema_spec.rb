describe OpenAPIParser::Schemas::Schema do
  let(:schema) do
    spec = File.read('spec/fixtures/schema.json')
               .then(&JSON.method(:parse))
               .then(&OpenAPIParser.method(:parse))
    spec.request_operation(:get, '/').operation_object.responses.response['200'].content['application/json'].schema
  end

  describe 'to_example' do
    let(:pattern) { /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/ }

    it 'generates array example' do
      expect(schema.to_example).to be_a_kind_of(Array)
    end

    it 'generates object example' do
      object = schema.items

      expect(object.to_example).to be_a_kind_of(Hash)
    end

    context 'string' do
      it 'generates example' do
        string = schema.items.properties['string']

        expect(string.to_example).to be_a_kind_of(String)
      end

      it 'generates pattern example' do
        string_pattern = schema.items.properties['string_pattern']

        expect(string_pattern.to_example).to be_a_kind_of(String).and match(pattern)
      end

      it 'generates enum example' do
        string_enum = schema.items.properties['string_enum']

        expect(string_enum.to_example).to eq('A').or eq('B')
      end

      it 'generates uri format example' do
        uri = schema.items.properties['string_uri'].to_example

        expect { URI.parse(uri) }.not_to raise_error
      end
    end

    context 'integer' do
      it 'generates example' do
        integer = schema.items.properties['integer']

        expect(integer.to_example).to be_a_kind_of(Integer)
      end

      it 'generates range example' do
        integer_range = schema.items.properties['integer_range']

        expect(integer_range.to_example).to be(1)
      end

      it 'generates enum example' do
        integer_enum = schema.items.properties['integer_enum']

        expect(integer_enum.to_example).to eq(1).or eq(2)
      end
    end

    it 'generates number example' do
      number = schema.items.properties['number']

      expect(number.to_example).to be_a_kind_of(Float)
    end

    it 'generates boolean example' do
      boolean = schema.items.properties['boolean']

      expect(boolean.to_example).to be_a_kind_of(TrueClass).or be_a_kind_of(FalseClass)
    end

    it 'recursively generates example' do
      example = schema.to_example

      expect(example.first).to include(
        'string' => a_kind_of(String),
        'integer' => a_kind_of(Integer),
        'number' => a_kind_of(Float),
        'boolean' => a_kind_of(TrueClass).or(be_a_kind_of(FalseClass))
      )
    end
  end

  describe 'type' do
    it 'infers object' do
      object = schema.items.properties['implied_object']

      expect(object.type).to eq('object')
    end

    it 'infers array' do
      array = schema.items.properties['implied_array']

      expect(array.type).to eq('array')
    end
  end
end
