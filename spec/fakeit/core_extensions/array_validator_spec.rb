describe OpenAPIParser::SchemaValidator::ArrayValidator do
  let(:schema) { double(OpenAPIParser::Schemas::Schema) }
  let(:keyword_args) { { some: 'args' } }

  subject { OpenAPIParser::SchemaValidator::ArrayValidator.new(nil, nil) }

  describe 'coerce_and_validate' do
    context 'when parameter schema' do
      before(:each) do
        allow(schema).to receive_message_chain(:parent, :is_a?).and_return(true)
      end

      it 'coerces non array to array' do
        expect(subject).to receive(:old_impl).with([1], schema, **keyword_args)

        subject.coerce_and_validate(1, schema, **keyword_args)
      end

      it 'coerces nil to empty array' do
        expect(subject).to receive(:old_impl).with([], schema, **keyword_args)

        subject.coerce_and_validate(nil, schema, **keyword_args)
      end

      it 'keeps array value' do
        expect(subject).to receive(:old_impl).with([1], schema, **keyword_args)

        subject.coerce_and_validate([1], schema, **keyword_args)
      end
    end

    context 'when other schema' do
      before(:each) do
        allow(schema).to receive_message_chain(:parent, :is_a?).and_return(false)
      end

      it 'does not coerces non array to array' do
        expect(subject).to receive(:old_impl).with(1, schema, **keyword_args)

        subject.coerce_and_validate(1, schema, **keyword_args)
      end
    end
  end
end
