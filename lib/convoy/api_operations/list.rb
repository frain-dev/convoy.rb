require "json"

module Convoy
  module ApiOperations
    module List
      module ClassMethods
        def list
          resource = self.new
          resource.list

          resource
        end
      end

      def list
        response = send_request(resource_url, :get)

        data = JSON.parse(response.body)["data"]
        @data = data
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end
    end
  end
end
