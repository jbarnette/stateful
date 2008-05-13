require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Event #:nodoc:
      def initialize(event)
        @event = event
      end
      
      def update(&block)
        instance_eval(&block)
      end
      
      def moves(pair)
        raise BadTransition.new(pair) unless Hash === pair && pair.size == 1
        @event.transitions.merge!(pair)
      end
      
      def stays(state)
        moves(state => state)
      end
    end
  end
end
