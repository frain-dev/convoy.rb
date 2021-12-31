module Convoy
  class DeliveryAttempt < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(eventId = nil, id = nil, config = Convoy.config)
      @eventId = eventId
      @id = id
      @config = config
    end

    def resource_url
      unless @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}" + 
               "/deliveryattempts"
      end

      "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}/deliveryattempts" + 
      "/#{@id}"
    end
  end
end
