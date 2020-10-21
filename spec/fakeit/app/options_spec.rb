describe Fakeit::App::Options do
  it 'uses static when global static toggle is true' do
    option = Fakeit::App::Options.new(static: true)

    expect(option.use_static?(type: 'string')).to be(true)
  end

  it 'uses static when type in static types' do
    option = Fakeit::App::Options.new(static_types: ['string'])

    expect(option.use_static?(type: 'string')).to be(true)
  end

  it 'uses static when type in static properties' do
    option = Fakeit::App::Options.new(static_properties: ['id'])

    expect(option.use_static?(property: 'id')).to be(true)
  end

  it 'not uses static when no static options matches' do
    option = Fakeit::App::Options.new(static_types: ['string'], static_properties: ['id'])

    expect(option.use_static?(type: 'integer', property: 'name')).to be(false)
  end

  it 'to hash' do
    option = Fakeit::App::Options.new

    expect(option.to_hash).to eq({
      permissive: false,
      use_example: false,
      static: false,
      static_types: [],
      static_properties: []
    })
  end
end
