require "net/http"
require "json"

module Convoy
  module ApiOperations
    module Request
      def send_request(uri, method, params = {}, config = Convoy.config, **kwargs)
        # Determine URL.
        uri = URI(uri)
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

        request.basic_auth config.username, config.password


        # Build HTTP Client.
        client = Net::HTTP.new(uri.host, uri.port)
        client.use_ssl = config.ssl
        client.open_timeout = 10
        client.read_timeout = 10
        client.continue_timeout = 10
        client.ssl_timeout = 10

        # TODO: Make this configurable
        client.set_debug_output $stderr

        # Make request.
        client.request(request)
      end
    end
  end
end
