module Convoy
  class EventDelivery < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def intialize(eventId = nil, id = nil, config = Convoy.config, **kwargs)
      @eventId = eventId
      @params = kwargs[:params].nil? ? {} : kwargs[:params]
      @id = id
      @config = config
    end

    def resource_url
      if @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}" +
          "/eventdelivery"
      end

      "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}/eventdelivery" +
      "/#{@id}"
    end

    # TODO: resend event delivery.

  end
end
