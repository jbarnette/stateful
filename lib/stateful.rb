require "stateful/version"
require "stateful/machine"
require "stateful/state"
require "stateful/event"

module Stateful
  class BadTransition < StandardError
    def initialize(bad)
      super("Bad transition: #{bad.inspect}")
    end    
  end
end