require "convoy/version"
require "zeitwerk"
require "forwardable"

loader = Zeitwerk::Loader.for_gem
loader.enable_reloading

# Collapse resource directory
resources_dir = "#{__dir__}/convoy/resources"
loader.collapse(resources_dir)
loader.setup 

module Convoy

  @config = ConvoyConfiguration.new
  
  class << self
    extend Forwardable

    attr_reader :config

    # User configurable options
    # Some of them have defaults
    def_delegators :@config, :ssl, :ssl=
    def_delegators :@config, :debug, :debug=
    def_delegators :@config, :api_key, :api_key=
    def_delegators :@config, :base_uri, :base_uri=
    def_delegators :@config, :logger, :logger=
    def_delegators :@config, :log_level, :log_level=
    def_delegators :@config, :path_version, :path_version=
    def_delegators :@config, :project_id, :project_id=
  end
end
