require "stateful/listeners"

module Stateful
  class Event
    include Stateful::Listeners
    
    attr_reader :name, :transitions
    
    def initialize(name)
      @name = name
      @transitions = {}
    end
  end
end
