describe OpenAPIParser::Schemas::Schema do
  let(:schema) do
    spec = File.read('spec/fixtures/schema.json')
               .then(&JSON.method(:parse))
               .then(&OpenAPIParser.method(:parse))
    spec.request_operation(:get, '/').operation_object.responses.response['200'].content['application/json'].schema
  end

  let(:pattern) { /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/ }

  it 'generates array example' do
    expect(schema.to_example).to be_a_kind_of(Array)
  end

  it 'generates object example' do
    object_schema = schema.items

    expect(object_schema.to_example).to be_a_kind_of(Hash)
  end

  it 'generates string pattern example' do
    string_pattern_schema = schema.items.properties['string_pattern']

    expect(string_pattern_schema.to_example).to be_a_kind_of(String).and match(pattern)
  end

  it 'generates string example' do
    string_schema = schema.items.properties['string']

    expect(string_schema.to_example).to be_a_kind_of(String)
  end

  it 'generates string enum example' do
    string_enum_schema = schema.items.properties['string_enum']

    expect(string_enum_schema.to_example).to eq('A').or eq('B')
  end

  it 'generates integer example' do
    integer_schema = schema.items.properties['integer']

    expect(integer_schema.to_example).to be_a_kind_of(Integer)
  end

  it 'generates integer range example' do
    integer_range_schema = schema.items.properties['integer_range']

    expect(integer_range_schema.to_example).to be(1)
  end

  it 'generates integer enum example' do
    integer_enum_schema = schema.items.properties['integer_enum']

    expect(integer_enum_schema.to_example).to eq(1).or eq(2)
  end

  it 'generates number example' do
    number_schema = schema.items.properties['number']

    expect(number_schema.to_example).to be_a_kind_of(Float)
  end

  it 'generates boolean example' do
    boolean_schema = schema.items.properties['boolean']

    expect(boolean_schema.to_example).to be_a_kind_of(TrueClass).or be_a_kind_of(FalseClass)
  end

  it 'recursively generates example' do
    example = schema.to_example

    expect(example.first).to include(
      'string_pattern' => a_kind_of(String).and(match(pattern)),
      'string' => a_kind_of(String),
      'string_enum' => eq('A').or(eq('B')),
      'integer' => a_kind_of(Integer),
      'integer_enum' => eq(1).or(eq(2)),
      'number' => a_kind_of(Float),
      'boolean' => a_kind_of(TrueClass).or(be_a_kind_of(FalseClass))
    )
  end
end
