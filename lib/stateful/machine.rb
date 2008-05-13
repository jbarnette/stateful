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
    
    def update(options={}, &block)
      @start = options[:start] if options[:start]
      Stateful::Builders::Machine.new(self).update(&block) if block_given?
      self
    end
    
    def execute(model, name)
      raise Stateful::BadModel.new(model) unless Stateful::Support === model
      
      now   = model.current_state
      event = events[name] or raise EventNotFound.new(name)
      from  = states[now] or raise StateNotFound.new(now)
      dest  = event.transitions[now] or raise BadTransition.new(model, event)
      to    = states[dest] or raise StateNotFound.new(dest)
      args  = model, event.name, to.name, from.name
      
      multicast(event, :firing, args)
      multicast(from, :exiting, args)
      multicast(to, :entering, args)
      
      model.current_state = to.name
      
      multicast(to, :entered, args)
      multicast(event, :fired, args)
    end
    
    private
    
    def multicast(target, event_name, args)
      fire(event_name, *args)
      target.fire(event_name, *args)
    end
  end
end
