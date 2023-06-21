module Convoy
  class Endpoint < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(id = nil, config = Convoy.config, **kwargs)
      @id = id
      @config = config 

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/endpoints"
      end

      "#{project_base_uri}/endpoints/#{@id}"
    end

    def pause
      pause_uri = "#{resource_uri}/pause"
      send_request(pause_uri, :post, data: @data, params: @params)
    end
  end
end
