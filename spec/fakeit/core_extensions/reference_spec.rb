describe OpenAPIParser::Schemas::Reference do
  let(:schema) do
    load_schema('reference')
  end

  describe 'to_example' do
    it 'invalid reference' do
      expect { schema.properties['invalid_ref'].to_example({}) }
        .to raise_error(Fakeit::Openapi::ReferenceError, 'Invalid $ref at "#/components/schemas/invalid"')
    end
  end
end
