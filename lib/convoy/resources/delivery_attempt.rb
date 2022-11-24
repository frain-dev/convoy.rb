module Convoy
  class DeliveryAttempt < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(eventId = nil, id = nil, config = Convoy.config, **kwargs)
      @id = id
      @eventId = eventId
      @config = config
      
      super(kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/events/#{@eventId}/deliveryattempts"
      end

      "#{project_base_uri}/events/#{@eventId}/deliveryattempts/#{@id}"
    end
  end
end
