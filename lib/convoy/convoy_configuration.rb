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

    def initialize
      @base_uri = "https://dashboard.getconvoy.io/api"
      @path_version = "/v1"
      @ssl = true
      @debug = false
    end

  end
end
