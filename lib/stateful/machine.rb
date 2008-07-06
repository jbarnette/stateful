require "stateful/builders/machine"
require "stateful/listeners"

module Stateful
  class Machine
    include Stateful::Listeners

    attr_reader   :events
    attr_accessor :start
    attr_reader   :states
    
    def initialize
      @events = {}
      @states = {}
    end
    
    def apply(options={}, &block)
      Stateful::Builders::Machine.new(self).apply(options, &block)
    end
        
    def accessorize(target)
      @states.keys.each do |name|
        unless target.method_defined?("#{name}?")
          target.class_eval <<-RUBY
            def #{name}?
              current_state == #{name.inspect}
            end
          RUBY
        end
      end
      
      @events.keys.each do |name|
        unless target.method_defined?("#{name}!")
          target.class_eval <<-RUBY
            def #{name}!
              self.class.statefully.execute(self, #{name.inspect})
            end
          RUBY
        end
      end
      
      self
    end
    
    def execute(model, name)
      raise Stateful::BadModel.new(model) unless model.class.stateful?
      
      now   = model.current_state
      event = events[name] or raise EventNotFound.new(name)
      from  = states[now] or raise StateNotFound.new(now)
      dest  = event.transitions[now] or raise BadTransition.new(model, event)
      to    = states[dest] or raise StateNotFound.new(dest)
      args  = model, event.name, to.name, from.name
      
      fire(event, :firing, args)
      fire(from, :exiting, args)
      fire(to, :entering, args)
      
      # 'internal' event
      fire(to, :persisting, args)

      model.current_state = to.name

      # 'internal' event
      fire(to, :persisted, args)
      
      fire(to, :entered, args)
      fire(event, :fired, args)
      
      self
    end
    
    def to_dot
      out = "digraph machine {"
      
      events.each do |name, event|
        event.transitions.each do |from, to|
          out << %Q[#{from}->#{to} [label="#{name}"]\n]
        end
      end
      
      out << "}"
    end
    
    private
    
    def fire(target, event_name, args)
      super(event_name, *args) # first fire the global listeners,
      target.fire(event_name, *args) # then the ones for a specific state/event
    end
  end
end
