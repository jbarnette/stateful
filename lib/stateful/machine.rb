require "stateful/builders/machine"
require "stateful/listeners"

module Stateful
  class Machine
    include Stateful::Listeners

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
