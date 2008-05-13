require "stateful/builders/machine"

module Stateful
  class Machine
    attr_reader   :events
    attr_accessor :start
    attr_reader   :states
    
    def initialize
      @events = {}
      @states = {}
    end
    
    def update(options={}, &block)
      @start = options[:start] if options[:start]
      Stateful::Builders::Machine.new(self).update(&block) if block_given?
      self
    end
  end
end
