module JsonApiTestHelpers
  module Params
    def json_api_params(attributes)
      { data: { attributes: attributes } }
    end
  end
end
