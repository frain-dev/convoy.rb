module Convoy
  class PortalLink < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::List
    include ApiOperations::Delete
    extend ApiOperations::Create

    def initialize(id = nil, config = Convoy.config, **kwargs)
      @id = id
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/portal-links"
      end

      "#{project_base_uri}/portal-links/#{@id}"
    end
  end
end
