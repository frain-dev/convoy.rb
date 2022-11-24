module Convoy
  class EventDelivery < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def intialize(eventId = nil, id = nil, config = Convoy.config, **kwargs)
      @id = id
      @eventId = eventId
      @config = config

      super(kwargs)
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
