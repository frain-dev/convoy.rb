module Convoy
  class DeliveryAttempt < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(event_delivery_id = nil, id = nil, config = Convoy.config, **kwargs)
      @event_delivery_id = event_delivery_id
      @id = id
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/eventdeliveries/#{@event_delivery_id}/deliveryattempts"
      end

      "#{project_base_uri}/eventdeliveries/#{@event_delivery_id}/deliveryattempts/#{@id}"
    end
  end
end
