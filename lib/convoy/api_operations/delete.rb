module Convoy
  module ApiOperations
    module Delete
      module ClassMethods
        def delete(id)
          resource = self.new(id)
          resource.delete

          resource
        end
      end

      def delete
        send_request(resource_uri, :delete, params: @params)
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end

    end
  end
end
