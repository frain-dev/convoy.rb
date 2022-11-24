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

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/events/#{@eventId}/eventdelivery"
      end

      "#{project_base_uri}/events/#{@eventId}/eventdelivery/#{@id}"
    end

    # TODO: resend event delivery.

  end
end
