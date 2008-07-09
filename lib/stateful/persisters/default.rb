module Stateful
  module Persisters
    class Default
      def persist(model, state)
        raise "I don't know how to persist state changes. Sorry!"
      end
      
      def state_of(model)
        raise "I don't know how to persist state changes. Sorry!"
      end

      def accessorize(target) end      
    end
  end
end
