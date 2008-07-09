module Stateful
  module Persisters
    class Attribute
      def persist(model, state)
        model.current_state = state
      end
      
      def state_of(model)
        model.current_state
      end

      def accessorize(target)
        unless target.respond_to?(:current_state)
          target.class_eval <<-RUBY
            def current_state
              @current_state ||= self.class.statefully.start
            end
          RUBY
        end

        unless target.respond_to?(:current_state=)
          target.class_eval <<-RUBY
            attr_writer :current_state
          RUBY
        end
      end
    end
  end
end
