module OpenAPIParser
  module Findable
    def purge_object_cache
      return if @purged

      @find_object_cache = {}
      @purged = true

      _openapi_all_child_objects.values.each(&:purge_object_cache)
    end
  end
end
