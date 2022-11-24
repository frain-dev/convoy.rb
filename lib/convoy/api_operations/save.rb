module Convoy
  module ApiOperations
    module Save
      module ClassMethods
        def update(id, **kwargs)
          resource = self.new(id, **kwargs)
          resource.update

          resource
        end
      end

      def update(data = {})
        @data = data unless data.empty?
        send_request(resource_uri, :put, data: @data, params: @params)
      end

      def save
        method = @id.nil? ? :post : :put
        send_request(resource_uri, method, data: @data, params: @params)
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end
    end
  end
end
