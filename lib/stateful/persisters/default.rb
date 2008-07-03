module Stateful
  module Persisters
    module Default
      def self.included(target)
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
