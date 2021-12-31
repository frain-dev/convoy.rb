module Convoy
  class Endpoint < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(appId = nil, id = nil, config = Convoy.config, **kwargs)
      @appId = appId
      @id = id
      @data = kwargs[:data].nil? ? {} : kwargs[:data]
    end

    def resource_url
      unless @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/applications/#{@appId}/endpoints"
      end

      "#{@config.base_uri}/#{@config.path_version}/applications/#{@appId}/endpoints" +
      "/#{@id}"
    end
  end
end
