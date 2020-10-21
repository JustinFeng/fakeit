describe Fakeit::App::Helpers::ResponseBuilder do
  subject { Fakeit::App::Helpers::ResponseBuilder }

  let(:headers) { { 'Content-Type' => 'application/json' } }

  it 'error' do
    expect(subject.error(418, StandardError.new('some error'))).to eq([418, headers, ['{"message":"some error"}']])
  end

  it 'not_found' do
    expect(subject.not_found).to eq([404, {}, ['Not Found']])
  end

  it 'method_not_allowed' do
    expect(subject.method_not_allowed).to eq([405, {}, ['Method Not Allowed']])
  end

  it 'ok' do
    expect(subject.ok({})).to eq([200, headers, ['{}']])
  end
end
