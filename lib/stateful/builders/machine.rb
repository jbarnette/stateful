require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Machine #:nodoc:
      def initialize(target)
        @target = target
      end
      
      def update(&block)
        instance_eval(&block)
      end
      
      def event(event, &block)
        target = (@target.events[event] ||= Stateful::Event.new)
        Stateful::Builders::Event.new(target).update(&block) if block_given?
      end
      
      def start(state)
        @target.start = state
      end
      
      def state(state)
        @target.states[state] ||= Stateful::State.new
      end
      
      def states(*states)
        states.each { |s| state s }
      end
    end
  end
end
