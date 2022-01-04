module Convoy
  module ApiOperations
    module Create
      def create(**kwargs)
        resource = self.new(**kwargs)
        resource.save

        resource
      end
    end
  end
end
