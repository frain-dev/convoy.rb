module Convoy
  class EventDelivery < ApiResource
    include ApiOperations::Get
    include ApiOperations::List

    def initialize(event_id = nil, id = nil, config = Convoy.config, **kwargs)
      @event_id = event_id
      @id = id
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/eventdeliveries"
      end

      "#{project_base_uri}/eventdeliveries/#{@id}"
    end

    def retry
      raise ArgumentError, "event delivery id is required to retry" if @id.nil?

      retry_uri = "#{resource_uri}/resend"
      send_request(retry_uri, :put, data: @data, params: @params)
    end

    # Collection-level route (POST /eventdeliveries/forceresend); the server
    # reads delivery IDs from the body, so ignore any @id on this instance.
    def force_retry
      force_retry_uri = "#{collection_uri}/forceresend"
      send_request(force_retry_uri, :post, data: @data, params: @params)
    end

    # Collection-level route; batch retries deliveries matching the query
    # params only (e.g. endpointId, eventId, status), with an empty body.
    def batch_retry
      batch_retry_uri = "#{collection_uri}/batchretry"
      send_request(batch_retry_uri, :post, data: {}, params: @params)
    end

    private

    def collection_uri
      "#{project_base_uri}/eventdeliveries"
    end
  end
end
