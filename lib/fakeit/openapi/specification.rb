module Fakeit::Openapi
  class Specification
    attr_reader :doc

    def initialize(doc)
      @doc = doc
    end
  end
end
