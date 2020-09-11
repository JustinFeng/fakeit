describe Fakeit::Openapi::Example do
  let(:schema) { load_schema('string_schema') }

  let(:use_static) { double('lambda', :[] => false) }
  let(:example_options) { { use_static: use_static, property: 'static_string' } }

  it 'calls use_static' do
    expect(use_static).to receive(:[]).with(type: 'string', property: 'static_string')

    schema.properties['string'].to_example(example_options)
  end

  context 'static' do
    let(:use_static) { double('lambda', :[] => true) }

    it 'default string example' do
      string = schema.properties['string']

      expect(string.to_example(example_options)).to eq('string')
    end

    it 'enum example' do
      string_enum = schema.properties['string_enum']

      expect(string_enum.to_example(example_options)).to eq('A')
    end

    it 'pattern example' do
      string_pattern = schema.properties['string_pattern']

      expect(string_pattern.to_example(example_options)).to eq('000')
    end

    it 'uri format example' do
      uri = schema.properties['string_uri']

      expect(uri.to_example(example_options)).to eq('https://some.uri')
    end

    it 'uuid format example' do
      uuid = schema.properties['string_uuid']

      expect(uuid.to_example(example_options)).to eq('11111111-1111-1111-1111-111111111111')
    end

    it 'guid format example' do
      guid = schema.properties['string_guid']

      expect(guid.to_example(example_options)).to eq('11111111-1111-1111-1111-111111111111')
    end

    it 'email format example' do
      email = schema.properties['string_email']

      expect(email.to_example(example_options)).to eq('some@email.com')
    end

    it 'date format example' do
      allow(Date).to receive(:today).and_return(Date.new(2019, 6, 1))

      date = schema.properties['string_date']

      expect(date.to_example(example_options)).to eq('2019-06-01')
    end

    it 'date time format example' do
      time = Time.new(2019, 6, 1, 12, 59, 59, '+08:00')
      allow(Time).to receive(:now).and_return(time)

      date_time = schema.properties['string_date_time']

      expect(date_time.to_example(example_options)).to eq('2019-06-01T00:00:00+08:00')
    end

    it 'binary format example' do
      binary = schema.properties['string_binary']

      expect(binary.to_example(example_options)).to eq('binary')
    end

    it 'byte format example' do
      byte = schema.properties['string_byte']

      expect(byte.to_example(example_options)).to eq('Ynl0ZQ==')
    end

    it 'min and max example' do
      length = schema.properties['string_min_max']

      expect(length.to_example(example_options)).to eq('1' * 3)
    end

    it 'min example' do
      length = schema.properties['string_min']

      expect(length.to_example(example_options)).to eq('1' * 30)
    end

    it 'max example' do
      length = schema.properties['string_max']

      expect(length.to_example(example_options)).to eq('1' * 3)
    end

    it 'unknown format example' do
      unknown = schema.properties['string_unknown']

      expect(unknown.to_example(example_options)).to eq('Unknown string format')
    end
  end

  context 'random' do
    it 'default string example' do
      expect(Faker::Book).to receive(:title).and_return('string')

      string = schema.properties['string']

      expect(string.to_example(example_options)).to eq('string')
    end

    it 'enum example' do
      string_enum = schema.properties['string_enum']

      expect(string_enum.to_example(example_options)).to eq('A').or eq('B')
    end

    it 'pattern example' do
      pattern = '^\\d{3}$'
      regexp = double(Regexp, random_example: 'matched_string')
      expect(Regexp).to receive(:new).with(pattern).and_return(regexp)

      string_pattern = schema.properties['string_pattern']

      expect(string_pattern.to_example(example_options)).to eq('matched_string')
    end

    it 'uri format example' do
      expect(Faker::Internet).to receive(:url).and_return('url')

      uri = schema.properties['string_uri']

      expect(uri.to_example(example_options)).to eq('url')
    end

    it 'uuid format example' do
      expect(SecureRandom).to receive(:uuid).and_return('uuid')

      uuid = schema.properties['string_uuid']

      expect(uuid.to_example(example_options)).to eq('uuid')
    end

    it 'guid format example' do
      expect(SecureRandom).to receive(:uuid).and_return('guid')

      guid = schema.properties['string_guid']

      expect(guid.to_example(example_options)).to eq('guid')
    end

    it 'email format example' do
      expect(Faker::Internet).to receive(:email).and_return('email')

      email = schema.properties['string_email']

      expect(email.to_example(example_options)).to eq('email')
    end

    it 'date format example' do
      date = Date.new(2019, 6, 1)
      expect(Faker::Date).to receive(:backward).with(days: 100).and_return(date)

      date = schema.properties['string_date']

      expect(date.to_example(example_options)).to eq('2019-06-01')
    end

    it 'date time format example' do
      time = Time.new(2019, 6, 1, 12, 59, 59, '+10:00')
      expect(Faker::Time).to receive(:backward).with(days: 100).and_return(time)

      date_time = schema.properties['string_date_time']

      expect(date_time.to_example(example_options)).to eq('2019-06-01T12:59:59+10:00')
    end

    it 'binary format example' do
      expect(Faker::String).to receive(:random).with(length: 1..30).and_return('binary')

      binary = schema.properties['string_binary']

      expect(binary.to_example(example_options)).to eq('binary')
    end

    it 'byte format example' do
      expect(Faker::String).to receive(:random).with(length: 1..30).and_return('byte')

      byte = schema.properties['string_byte']

      expect(byte.to_example(example_options)).to eq('Ynl0ZQ==')
    end

    it 'min and max example' do
      expect(Faker::Internet).to receive(:username).with(specifier: 1..3).and_return('m&m')

      length = schema.properties['string_min_max']

      expect(length.to_example(example_options)).to eq('m&m')
    end

    it 'min example' do
      expect(Faker::Internet).to receive(:username).with(specifier: 20..30).and_return('min')

      length = schema.properties['string_min']

      expect(length.to_example(example_options)).to eq('min')
    end

    it 'max example' do
      expect(Faker::Internet).to receive(:username).with(specifier: 0..3).and_return('max')

      length = schema.properties['string_max']

      expect(length.to_example(example_options)).to eq('max')
    end

    it 'unknown format example' do
      unknown = schema.properties['string_unknown']

      expect(unknown.to_example(example_options)).to eq('Unknown string format')
    end
  end
end
