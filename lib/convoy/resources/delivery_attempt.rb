module Convoy
  class DeliveryAttempt < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(eventId = nil, id = nil, config = Convoy.config, **kwargs)
      @eventId = eventId
      @id = id
      @params = kwargs[:params].nil? ? {} : kwargs[:params]
      @config = config
    end

    def resource_url
      if @id.nil?
        return "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}" + 
               "/deliveryattempts"
      end

      "#{@config.base_uri}/#{@config.path_version}/events/#{@eventId}/deliveryattempts" + 
      "/#{@id}"
    end
  end
end
