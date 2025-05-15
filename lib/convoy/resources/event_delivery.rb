module Convoy
  class EventDelivery < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(eventId = nil, id = nil, config = Convoy.config, **kwargs)
      @id = id
      @eventId = eventId
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/events/#{@eventId}/eventdelivery"
      end

      "#{project_base_uri}/events/#{@eventId}/eventdelivery/#{@id}"
    end

    
    def retry
      retry_uri = "#{resource_uri}/resend"
      send_request(retry_uri, :put, data: @data, params: @params)
    end

    def force_retry
      force_retry_uri = "#{resource_uri}/forceresend"
      send_request(force_retry_uri, :post, data: @data, params: @params)
    end
  end
end
