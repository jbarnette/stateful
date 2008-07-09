require "stateful/persisters/default"
require "stateful/persisters/activerecord"

module Stateful
  module Persisters
    def self.decorate(klass)
      klass.send(:include, Stateful::Persisters::Default)
    end    
  end
end
