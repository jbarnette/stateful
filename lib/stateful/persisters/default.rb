module Stateful
  module Persisters
    module Default
      def self.included(target)
        unless target.method_defined?(:current_state)
          target.class_eval <<-END, __FILE__, __LINE__
            def current_state
              @current_state ||= self.class.statefully.start
            end
          END
        end
        
        unless target.method_defined?(:current_state=)
          target.class_eval <<-END, __FILE__, __LINE__
            attr_writer :current_state
          END
        end
      end
    end
  end
end
