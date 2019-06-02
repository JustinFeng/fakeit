describe OpenAPIParser::Schemas::Schema do
  let(:schema) do
    spec = File.read('spec/fixtures/schema.json')
               .then(&JSON.method(:parse))
               .then(&OpenAPIParser.method(:parse))
    spec.request_operation(:get, '/').operation_object.responses.response['200'].content['application/json'].schema
  end

  describe 'to_example' do
    let(:pattern) { /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/ }

    context 'random generates' do
      it 'array example' do
        expect(schema.to_example).to be_a_kind_of(Array)
      end

      it 'object example' do
        object = schema.items

        expect(object.to_example).to be_a_kind_of(Hash)
      end

      context 'string' do
        it 'default example' do
          string = schema.items.properties['string']

          expect(string.to_example).to be_a_kind_of(String)
        end

        it 'pattern example' do
          string_pattern = schema.items.properties['string_pattern']

          expect(string_pattern.to_example).to be_a_kind_of(String).and match(pattern)
        end

        it 'enum example' do
          string_enum = schema.items.properties['string_enum']

          expect(string_enum.to_example).to eq('A').or eq('B')
        end

        it 'uri format example' do
          uri = schema.items.properties['string_uri'].to_example

          expect { URI.parse(uri) }.not_to raise_error
        end
      end

      context 'integer' do
        it 'default example' do
          integer = schema.items.properties['integer']

          expect(integer.to_example).to be_a_kind_of(Integer)
        end

        it 'range example' do
          integer_range = schema.items.properties['integer_range']

          expect(integer_range.to_example).to be(1)
        end

        it 'enum example' do
          integer_enum = schema.items.properties['integer_enum']

          expect(integer_enum.to_example).to eq(1).or eq(2)
        end
      end

      it 'number example' do
        number = schema.items.properties['number']

        expect(number.to_example).to be_a_kind_of(Float)
      end

      it 'boolean example' do
        boolean = schema.items.properties['boolean']

        expect(boolean.to_example).to be_a_kind_of(TrueClass).or be_a_kind_of(FalseClass)
      end

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
