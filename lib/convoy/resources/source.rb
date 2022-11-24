module Convoy
  class Source < ApiResource
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(id = nil, config = Convoy.config, **kwargs)
      @id = id
      @data = kwargs[:data].nil? ? {} : kwargs[:data]
      @params = kwargs[:params].nil? ? {} : kwargs[:params]
      @config = config
    end

    def resource_uri 
      if @id.nil?
        return "#{project_base_uri}/sources"
      end

      "#{project_base_uri}/sources/#{@id}"
    end
  end
end
