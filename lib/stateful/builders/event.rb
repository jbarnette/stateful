require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Event #:nodoc:
      def initialize(parent, event)
        @parent = parent
        @event = event
      end
      
      def apply(&block)
        instance_eval(&block)
      end
      
      def changes(pair)
        unless Hash === pair && pair.size == 1
          raise ArgumentError.new("Not a pair: #{pair.inspect}")
        end
        
        # ensure all referenced states exist
        pair.to_a.flatten.each { |n| @parent.state(n) }
        
        froms, to = pair.keys.first, pair.values.first
        Array(froms).each { |from| @event.transitions[from] = to }
      end
      
      def stays(*names)
        names.each { |n| changes(n => n) }
      end
    end
  end
end
