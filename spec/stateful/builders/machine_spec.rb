require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

require "stateful/builders/machine"

describe Stateful::Builders::Machine do
  before :each do
    @builder = Stateful::Builders::Machine.new(mock("machine", :events => {}, :states => {}))
    
    @builder.machine.stub!(:start)
    @builder.machine.stub!(:start=)
  end
  
  describe "#event" do
    it "ensures the specified event exists" do
      @builder.event(:open)
      @builder.machine.events[:open].must_not be_nil
    end
    
    it "optionally yields a provided block to an event builder" do      
      e = @builder.event(:open) { stays :a }
      e.transitions[:a].must == :a
    end
  end
  
  describe "#start" do
    it "ensures the specified state exists" do
      @builder.start(:x)
      @builder.machine.states[:x].must_not be_nil
    end
    
    it "sets the start state on the target machine" do
      @builder.machine.should_receive(:start=).at_least(:once).with(:x)
      @builder.start(:x)
    end
  end
  
  describe "#state" do
    it "ensures the specified state exists" do
      @builder.machine.states.must be_empty
      @builder.state(:x).must_not be_nil
      @builder.machine.states[:x].must_not be_nil
    end
    
    it "sets the start state of the machine if it's empty" do
      @builder.machine.should_receive(:start=).with(:x)
      @builder.state(:x)
    end
  end
  
  describe "#states" do
    it "specified multiple states at once" do
      @builder.machine.states.must be_empty
      @builder.states(:x, :y, :z)
      @builder.machine.states.size.must == 3
    end
  end
  
  describe "#apply" do
    it "optionally specifies a start state" do
      @builder.machine.should_receive(:start=).at_least(:once).with(:x)
      @builder.apply(:start => :x)
    end
    
    it "instance evals a provided block" do
      @builder.apply { state :x }
      @builder.machine.states[:x].must_not be_nil
    end
  end
end