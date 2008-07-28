module Stateful
  class Context
    attr_reader :model
    attr_reader :event
    attr_reader :to
    attr_reader :from
    attr_reader :extras
    
    def initialize(model, event, to, from, extras)
      @model  = model
      @event  = event
      @to     = to
      @from   = from
      @extras = extras
    end
  end
end
