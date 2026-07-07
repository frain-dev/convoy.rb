require 'forwardable'

module Convoy

  # USAGE
  # resource = Convoy::Resource.create(args)
  # OR 
  # resource = Convoy::Resource.new(args)
  # resource.save
  #
  # Class methods - get, list, create, update, delete. These methods exist 
  # as helper methods.
  # Instance methods - get, list, save, delete, update. Core methods class 
  # methods rely on.
  class ApiResource
    extend Forwardable
    include Convoy::ApiOperations::Request

    # You must either use this or the list resource but cannot use object on 
    # the same instance. Each resource is either a container with one record 
    # or a list of records.
    def_delegator :@data, :[], :get_data
    def_delegator :@data, :[]=, :set_data

    # For list resources
    def_delegators :@data, :size, :map, :each

    attr_reader :response

    def initialize(**kwargs)
      @params = kwargs[:params].nil? ? {} : kwargs[:params]
      @query = kwargs[:query].nil? ? {} : kwargs[:query]
      @data = kwargs[:data].nil? ? {} : kwargs[:data]
    end

    def project_base_uri
      if @config.base_uri.nil?
        raise ArgumentError, "Base URI not supplied, e.g. Convoy.base_uri = \"https://us.getconvoy.cloud/api\""
      end

      if @config.project_id.nil?
        raise ArgumentError, "Project ID not supplied"
      end

      # path_version already starts with a slash; joining with another slash
      # produces "api//v1", which the server's router rejects with a 404.
      "#{@config.base_uri.chomp("/")}#{@config.path_version}/projects/#{@config.project_id}"
    end
  end
end
