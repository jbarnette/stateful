require File.expand_path("#{File.dirname(__FILE__)}/../helper")

require "stateful"

describe Stateful::Tracing do
  class AClassWithTracing
    include Stateful::Tracing
    
    statefully do
      start :inactive
      
      on :activate do
        moves :inactive => :active
      end
      
      on :deactivate do
        moves :active => :inactive
      end
    end
  end
  
  
end
