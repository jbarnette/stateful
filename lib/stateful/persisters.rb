require "stateful/persisters/default"
require "stateful/persisters/attribute"
require "stateful/persisters/activerecord"

module Stateful
  module Persisters
    def self.for(klass)
      return Stateful::Persisters::Attribute.new
    end    
  end
end
