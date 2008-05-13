module Stateful
  class BadTransition < StandardError
    def initialize(bad)
      super("Bad transition: #{bad.inspect}")
    end    
  end
end
