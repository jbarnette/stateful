module Stateful
  class BadModel < StandardError
    def initialize(model)
      super("#{model.inspect} isn't stateful")
    end    
  end

  class BadTransition < StandardError
    def initialize(bad)
      super("Bad transition: #{bad.inspect}")
    end
  end
  
  class EventNotFound < StandardError
    def initialize(event)
      super("Event not found: #{event.inspect}")
    end
  end
end
