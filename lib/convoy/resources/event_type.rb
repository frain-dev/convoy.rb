module Convoy
  class EventType < ApiResource
    include ApiOperations::Get
    include ApiOperations::List
    include ApiOperations::Save
    include ApiOperations::Create

    def initialize(id = nil, config = Convoy.config, **kwargs)
      @id = id 
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/event-types"
      end

      "#{project_base_uri}/event-types/#{@id}"
    end

    def deprecate
      deprecate_url = "#{resource_uri}/deprecate"
      send_request(deprecate_url, :post, data: @data, params: @params)
    end
  end
end
