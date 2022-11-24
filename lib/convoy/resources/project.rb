module Convoy
  class Project < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(id = nil, config = Convoy.config, **kwargs)
      @id = id
      @config = config

      super(kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/projects"
      end

      "#{@config.base_uri}/#{@config.path_version}/projects" + "/#{@id}"
    end

  end
end
