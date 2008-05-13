require "stateful/builders/event"

module Stateful #:nodoc:
  module Builders #:nodoc:
    class Machine #:nodoc:
      LISTENERS = { :event => [:firing, :fired], :state => [:entering, :entered, :exiting] }

      def initialize(machine)
        @machine = machine
      end
      
      def update(&block)
        instance_eval(&block)
      end
            
      def event(name, &block)
        event = @machine.events[name] ||= Stateful::Event.new
        Stateful::Builders::Event.new(event).update(&block) if block_given?
        event
      end
      
      def start(name)
        @machine.start = name
      end
      
      def state(name)
        state = @machine.states[name] ||= Stateful::State.new
        @machine.start = name unless @machine.start
        state
      end
      
      def states(*names)
        names.each { |n| state n }
      end
      
      LISTENERS.each do |source, kinds|
        kinds.each do |kind|
          class_eval <<-END, __FILE__, __LINE__
            def #{kind}(*names, &block)
              @machine.listeners(#{kind.inspect}) << block if names.empty?
              names.each { |n| #{source}(n).listeners(#{kind.inspect}) << block }
            end
          END
        end
      end      
    end
  end
end
