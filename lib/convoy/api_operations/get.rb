module Convoy
  module ApiOperations
    module Get
      module ClassMethods
        def self.get(id)
          resource = self.new(id)
          resource.get

          resource
        end
      end

      def get
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
