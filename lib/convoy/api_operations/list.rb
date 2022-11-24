require "json"

module Convoy
  module ApiOperations
    module List
      module ClassMethods
        def list(**kwargs)
          resource = self.new(**kwargs)
          resource.list

          resource
        end
      end

      def list
        send_request(resource_uri, :get, params: @params)
        @data = @response['data']
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end
    end
  end
end
