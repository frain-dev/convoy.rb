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
  end
end
