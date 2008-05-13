require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Machine #:nodoc:
      def initialize(machine)
        @machine = machine
      end
      
      def update(&block)
        instance_eval(&block)
      end
      
      def event(event, &block)
        target = @machine.events[event] ||= Stateful::Event.new
        Stateful::Builders::Event.new(target).update(&block) if block_given?
      end
      
      def start(state)
        @machine.start = state
      end
      
      def state(state)
        @machine.states[state] ||= Stateful::State.new
        @machine.start = state unless @machine.start
      end
      
      def states(*states)
        states.each { |s| state s }
      end
    end
  end
end
