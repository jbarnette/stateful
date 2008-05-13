require "stateful/listeners"

module Stateful
  class State
    include Stateful::Listeners
    
    attr_reader :name
    
    def initialize(name)
      @name = name
    end
  end
end
