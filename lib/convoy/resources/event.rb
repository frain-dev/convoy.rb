module Convoy
  class Event < ApiResource
    include ApiOperations::Get
    include ApiOperations::Save
    include ApiOperations::Delete
    include ApiOperations::List
    extend ApiOperations::Create

    def initialize(id = nil , config = Convoy.config, **kwargs)
      @id = id
      @config = config

      super(**kwargs)
    end

    def resource_uri
      if @id.nil?
        return "#{project_base_uri}/events"
      end

      "#{project_base_uri}/events/#{@id}"
    end

    # Collection-level routes; the server only registers them under /events,
    # never /events/{id}, so ignore any @id set on this instance.
    def fanout
      fanout_uri = "#{collection_uri}/fanout"
      send_request(fanout_uri, :post, data: @data, params: @params)
    end

    def dynamic
      dynamic_uri = "#{collection_uri}/dynamic"
      send_request(dynamic_uri, :post, data: @data, params: @params)
    end

    def broadcast
      broadcast_uri = "#{collection_uri}/broadcast"
      send_request(broadcast_uri, :post, data: @data, params: @params)
    end

    def replay
      raise ArgumentError, "event id is required to replay" if @id.nil?

      replay_uri = "#{resource_uri}/replay"
      send_request(replay_uri, :put, data: @data, params: @params)
    end

    private

    def collection_uri
      "#{project_base_uri}/events"
    end
  end
end
