describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('string_schema')
  end

  it 'string example' do
    string = schema.properties['string']

    expect(string.to_example).to be_a_kind_of(String)
  end

  it 'pattern example' do
    pattern = /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$/
    string_pattern = schema.properties['string_pattern']

    expect(string_pattern.to_example).to be_a_kind_of(String).and match(pattern)
  end

  it 'enum example' do
    string_enum = schema.properties['string_enum']

    expect(string_enum.to_example).to eq('A').or eq('B')
  end

  it 'uri format example' do
    uri = schema.properties['string_uri']

    expect { URI.parse(uri.to_example) }.not_to raise_error
  end

  it 'uuid format example' do
    uuid_pattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    uuid = schema.properties['string_uuid']

    expect(uuid.to_example).to match(uuid_pattern)
  end

  it 'email format example' do
    email = schema.properties['string_email']

    expect(email.to_example).to match(URI::MailTo::EMAIL_REGEXP)
  end

  it 'date format example' do
    rfc3339_date_pattern = /^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])$/
    date = schema.properties['string_date']

    expect(date.to_example).to match(rfc3339_date_pattern)
  end

  it 'date time format example' do
    rfc3339_date_time_pattern = /
      ^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])
      T
      (2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]
      ([Zz]|[\+|\-](2[0-3]|[01][0-9]):[0-5][0-9])$
    /x
    date_time = schema.properties['string_date_time']

    expect(date_time.to_example).to match(rfc3339_date_time_pattern)
  end

  it 'length example' do
    length = schema.properties['string_length']

    expect(length.to_example.length).to be_between(1, 3).inclusive
  end

  it 'unknown format example' do
    unknown = schema.properties['string_unknown']

    expect(unknown.to_example).to eq('Unknown string format')
  end
end
