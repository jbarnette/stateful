require "stateful/builders/machine"
require "stateful/listeners"

module Stateful
  class Machine
    include Stateful::Listeners

    attr_reader   :events
    attr_reader   :persister
    attr_accessor :start
    attr_reader   :states
    
    def initialize(persister=Stateful::Persisters::Default.new)
      @events    = {}
      @persister = persister
      @states    = {}
    end
    
    def apply(options={}, &block)
      Stateful::Builders::Machine.new(self).apply(options, &block)
    end
        
    def accessorize(target)
      persister.accessorize(target)
      
      states.keys.each do |name|
        unless target.method_defined?("#{name}?")
          target.send(:define_method, "#{name}?") do
            @persister.state_of(self)
          end
          # target.class_eval <<-RUBY
          #   def #{name}?
          #     self.class.statefully.persister.state_of(self) == #{name.inspect}
          #   end
          # RUBY
        end
      end
      
      events.keys.each do |name|
        unless target.method_defined?("#{name}!")
          # FIXME: define_method instead?
          target.class_eval <<-RUBY
            def #{name}!(extras={})
              self.class.statefully.execute(self, #{name.inspect}, extras)
            end
          RUBY
        end
      end
      
      self
    end
    
    def execute(model, name, extras={})
      raise Stateful::BadModel.new(model) unless model.class.stateful?
      
      now   = persister.state_of(model)
      event = events[name] or raise EventNotFound.new(name)
      from  = states[now] or raise StateNotFound.new(now)
      dest  = event.transitions[now] or raise BadTransition.new(model, event)
      to    = states[dest] or raise StateNotFound.new(dest)
      ctx   = Context.new(model, event.name, to.name, from.name, extras)
      
      fire(event, :firing, ctx)
      fire(from, :exiting, ctx)
      fire(to, :entering, ctx)
      
      # 'internal' event
      fire(to, :persisting, ctx)

      persister.persist(model, to.name)

      # 'internal' event
      fire(to, :persisted, ctx)
      
      fire(to, :entered, ctx)
      fire(event, :fired, ctx)
      
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
    
    def fire(target, event_name, ctx)
      super(event_name, ctx) # first fire the global listeners,
      target.fire(event_name, ctx) # then the ones for a specific state/event
    end
  end
end
