describe OpenAPIParser::Schemas::Schema do
  let(:schema) do
    load_schema('schema_type')
  end

  describe 'type' do
    it 'infers object' do
      object = schema.properties['implied_object']

      expect(object.type).to eq('object')
    end

    it 'infers array' do
      array = schema.properties['implied_array']

      expect(array.type).to eq('array')
    end
  end
end
