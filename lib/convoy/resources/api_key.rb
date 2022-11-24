module Convoy
  class ApiKey < ApiResource
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
        return "#{project_base_uri}/security/keys"
      end

      "#{project_base_uri}/security/keys/#{@id}"
    end
  end
end
