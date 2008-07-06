require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Event #:nodoc:
      attr_accessor :parent, :event
      
      def initialize(parent, event)
        @parent = parent
        @event = event
      end
      
      def apply(&block)
        instance_eval(&block)
      end
      
      def move(pair)
        unless Hash === pair && pair.size == 1
          raise ArgumentError.new("Not a pair: #{pair.inspect}")
        end
        
        # ensure all referenced states exist
        pair.to_a.flatten.uniq.each { |n| @parent.state(n) }
        
        froms, to = pair.keys.first, pair.values.first
        Array(froms).each { |from| @event.transitions[from] = to }

        # covers things like 'move :ANYTHING => :paused'
        @event.transitions.default = to if froms == :ANYTHING
      end
      
      def stay(*names)
        names.each { |n| move(n => n) }
      end
    end
  end
end
