# https://github.com/ota42y/openapi_parser/issues/75
module OpenAPIParser
  class PathItemFinder
    private

    def find_path_and_params(http_method, request_path)
      return [request_path, {}] if matches_directly?(request_path, http_method)

      matching = matching_paths_with_params(request_path, http_method)

      matching.min_by { |match| match[1].size }
    end
  end
end
