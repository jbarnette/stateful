module Stateful
  module Support
    attr_accessor :current_state

    def current_state
      @current_state ||= self.class.state_machine.start
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def state_machine
        @state_machine ||= Stateful::Machine.new
      end
    end
  end
end
