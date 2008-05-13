require "stateful/listeners"

module Stateful
  class Event
    include Stateful::Listeners
    
    attr_reader :transitions
    
    def initialize
      @transitions = {}
    end
  end
end
