describe Fakeit::Openapi::Example do
  let(:schema) do
    load_schema('string_schema')
  end

  it 'default string example' do
    expect(Faker::Book).to receive(:title).and_return('string')

    string = schema.properties['string']

    expect(string.to_example).to eq('string')
  end

  it 'enum example' do
    string_enum = schema.properties['string_enum']

    expect(string_enum.to_example).to eq('A').or eq('B')
  end

  it 'pattern example' do
    pattern = '^[12][0-9]{3}-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):[0-5][0-9]:[0-5][0-9]$'
    expect(Faker::Base).to receive(:regexify).with(pattern).and_return('matched_string')

    string_pattern = schema.properties['string_pattern']

    expect(string_pattern.to_example).to eq('matched_string')
  end

  it 'uri format example' do
    expect(Faker::Internet).to receive(:url).and_return('url')

    uri = schema.properties['string_uri']

    expect(uri.to_example).to eq('url')
  end

  it 'uuid format example' do
    expect(SecureRandom).to receive(:uuid).and_return('uuid')

    uuid = schema.properties['string_uuid']

    expect(uuid.to_example).to eq('uuid')
  end

  it 'email format example' do
    expect(Faker::Internet).to receive(:email).and_return('email')

    email = schema.properties['string_email']

    expect(email.to_example).to eq('email')
  end

  it 'date format example' do
    date = Date.new(2019, 6, 1)
    expect(Faker::Date).to receive(:backward).with(100).and_return(date)

    date = schema.properties['string_date']

    expect(date.to_example).to eq('2019-06-01')
  end

  it 'date time format example' do
    time = Time.new(2019, 6, 1, 12, 59, 59, '+10:00')
    expect(Faker::Time).to receive(:backward).with(100).and_return(time)

    date_time = schema.properties['string_date_time']

    expect(date_time.to_example).to eq('2019-06-01T12:59:59+10:00')
  end

  it 'min and max example' do
    expect(Faker::Internet).to receive(:user_name).with(1..3).and_return('m&m')

    length = schema.properties['string_min_max']

    expect(length.to_example).to eq('m&m')
  end

  it 'min example' do
    expect(Faker::Internet).to receive(:user_name).with(20..30).and_return('min')

    length = schema.properties['string_min']

    expect(length.to_example).to eq('min')
  end

  it 'max example' do
    expect(Faker::Internet).to receive(:user_name).with(0..3).and_return('max')

    length = schema.properties['string_max']

    expect(length.to_example).to eq('max')
  end

  it 'unknown format example' do
    unknown = schema.properties['string_unknown']

    expect(unknown.to_example).to eq('Unknown string format')
  end
end
