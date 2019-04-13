require 'fakeit/openapi/specification'

describe Fakeit::Openapi::Specification do
  subject { Fakeit::Openapi::Specification.new('doc') }

  it 'holds doc' do
    expect(subject.doc).to eq('doc')
  end
end
