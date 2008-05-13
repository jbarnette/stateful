module Stateful
  class Event
    attr_reader :transitions
    
    def initialize
      @transitions = {}
    end
  end
end
