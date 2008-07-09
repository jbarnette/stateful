module Stateful
  module Persisters
    class Default
      def accessorize(target) end
      
      def persist(model, state)
        raise "I don't know how to persist state changes. Sorry!"
      end
    end
  end
end
