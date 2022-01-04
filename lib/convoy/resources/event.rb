module Convoy
  class Event < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(id = nil , config = Convoy.config, **kwargs)
      @id = id
      @data = kwargs[:data].nil? ? {} : kwargs[:data]
      @params = kwargs[:params].nil? ? {} : kwargs[:params]
      @config = config
    end

    def resource_url
      if @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/events"
      end

      "#{@config.base_uri}/#{@config.path_version}/events/#{@id}"
    end
  end
end
