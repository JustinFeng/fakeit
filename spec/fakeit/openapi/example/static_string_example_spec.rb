describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('string_schema')
  end

  it 'default string example' do
    string = schema.properties['string']

    expect(string.to_example(static: true)).to eq('string')
  end

  it 'enum example' do
    string_enum = schema.properties['string_enum']

    expect(string_enum.to_example(static: true)).to eq('A')
  end

  it 'pattern example' do
    string_pattern = schema.properties['string_pattern']

    expect(string_pattern.to_example(static: true)).to eq('2950-01-30T21:47:56')
  end

  it 'uri format example' do
    uri = schema.properties['string_uri']

    expect(uri.to_example(static: true)).to eq('https://some.uri')
  end

  it 'uuid format example' do
    uuid = schema.properties['string_uuid']

    expect(uuid.to_example(static: true)).to eq('11111111-1111-1111-1111-111111111111')
  end

  it 'guid format example' do
    guid = schema.properties['string_guid']

    expect(guid.to_example(static: true)).to eq('11111111-1111-1111-1111-111111111111')
  end

  it 'email format example' do
    email = schema.properties['string_email']

    expect(email.to_example(static: true)).to eq('some@email.com')
  end

  it 'date format example' do
    allow(Date).to receive(:today).and_return(Date.new(2019, 6, 1))

    date = schema.properties['string_date']

    expect(date.to_example(static: true)).to eq('2019-06-01')
  end

  it 'date time format example' do
    time = Time.new(2019, 6, 1, 12, 59, 59, '+08:00')
    allow(Time).to receive(:now).and_return(time)

    date_time = schema.properties['string_date_time']

    expect(date_time.to_example(static: true)).to eq('2019-06-01T00:00:00+08:00')
  end

  it 'min and max example' do
    length = schema.properties['string_min_max']

    expect(length.to_example(static: true)).to eq('1' * 3)
  end

  it 'min example' do
    length = schema.properties['string_min']

    expect(length.to_example(static: true)).to eq('1' * 30)
  end

  it 'max example' do
    length = schema.properties['string_max']

    expect(length.to_example(static: true)).to eq('1' * 3)
  end

  it 'unknown format example' do
    unknown = schema.properties['string_unknown']

    expect(unknown.to_example(static: true)).to eq('Unknown string format')
  end
end
