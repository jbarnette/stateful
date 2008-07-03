require File.expand_path("#{File.dirname(__FILE__)}/../helper")

require "stateful/event"

describe Stateful::Event do
  before :each do
    @event = Stateful::Event.new(:x)
  end
  
  it "is initialized with a name" do
    @event.name.must == :x
  end
  
  it "has a hash of transitions" do
    @event.transitions.must == {}
  end
end
