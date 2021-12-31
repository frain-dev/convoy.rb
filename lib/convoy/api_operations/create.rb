module Convoy
  module ApiOperations
    module Create
      module ClassMethods
        def self.create(data)
          resource = self.new(data: data)
          resource.save

          resource
        end
      end

      def self.included(base)
        # Setup helper methods on Class.
        base.extend(ClassMethods)
      end
    end
  end
end
