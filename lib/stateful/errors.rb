module Stateful
  class BadModel < StandardError
    def initialize(model)
      super("#{model.inspect} isn't stateful")
    end    
  end

  class BadTransition < StandardError
    def initialize(model, event)
      current = model.class.statefully.persister.state_of(model)
      super("Can't #{event.name} while #{current}: #{model.inspect}")
    end
  end
  
  class EventNotFound < StandardError
    def initialize(name)
      super("Event not found: #{name}")
    end
  end
  
  class StateNotFound < StandardError
    def initialize(name)
      super("State not found: #{name}")
    end
  end
end
