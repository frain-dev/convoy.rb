module Convoy
  class ConvoyConfiguration

    attr_accessor :ssl
    attr_accessor :debug
    attr_accessor :api_key
    attr_accessor :base_uri
    attr_accessor :path_version
    attr_accessor :logger
    attr_accessor :log_level
    attr_accessor :project_id
    attr_accessor :http_open_timeout
    attr_accessor :http_read_timeout
    attr_accessor :http_continue_timeout
    attr_accessor :http_ssl_timeout

    def initialize
      @base_uri = "https://dashboard.getconvoy.io/api"
      @path_version = "/v1"
      @ssl = true
      @debug = false
      @http_open_timeout = 10
      @http_read_timeout = 10
      @http_continue_timeout = 10
      @http_ssl_timeout = 10
    end

  end
end
