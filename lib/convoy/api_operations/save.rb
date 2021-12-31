module Convoy
  module ApiOperations
    module Save
      module ClassMethods
        def update(id, data)
          resource = self.new(id, data: data)
          resource.update

          resource
        end
      end

      def update(data = {})
        @data = data unless data.empty?
        send_request(resource_url, :put, @data)
      end

      def save
        method = @id.nil? ? :post : :put
        send_request(resource_url, method, @data)
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end
    end
  end
end
