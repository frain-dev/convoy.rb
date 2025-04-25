require "net/http"
require "json"

module Convoy
  module ApiOperations
    module Request
      def send_request(uri, method, config = Convoy.config, **kwargs)
        # Determine URL.
        uri = URI(uri)
        params = kwargs[:params].nil? ? {} : kwargs[:params]
        uri.query = URI.encode_www_form(params) unless params.empty?

        # Build Request.
        request = case method.downcase.to_sym
                  when :post
                    req = Net::HTTP::Post.new(uri.request_uri)
                    data = kwargs[:data].nil? ? {} : kwargs[:data]
                    req['Content-Type'] = 'application/json'
                    req.body = JSON.dump(data)
                    
                    req
                  when :get
                    Net::HTTP::Get.new(uri.request_uri)
                  when :delete
                    Net::HTTP::Delete.new(uri.request_uri)
                  when :put
                    req = Net::HTTP::Put.new(uri.request_uri)
                    data = kwargs[:data].nil? ? {} : kwargs[:data]
                    req['Content-Type'] = 'application/json'
                    req.body = JSON.dump(data)

                    req
                  end

        if !config.api_key.nil?
          request['Authorization'] = "Bearer #{config.api_key}"
        end

        # Build HTTP Client.
        client = build_http_client(uri, config)

        # Make request.
        http_response = client.request(request)
        @response = JSON.parse(http_response.body)

        self
        # TODO: Perform err checks.
      end

      private

      def build_http_client(uri, config)
        client = Net::HTTP.new(uri.host, uri.port)

        client.use_ssl = config.ssl
        client.open_timeout = config.http_open_timeout
        client.read_timeout = config.http_read_timeout
        client.continue_timeout = config.http_continue_timeout
        client.ssl_timeout = config.http_ssl_timeout

        client.set_debug_output $stderr if config.debug

        client
      end
    end
  end
end
