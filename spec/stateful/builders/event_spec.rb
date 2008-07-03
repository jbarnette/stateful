require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

require "stateful/builders/event"

describe Stateful::Builders::Event do
  before :each do
    @builder = Stateful::Builders::Event.new(mock("parent"), mock("event", :transitions => {}))
  end

  describe "#moves" do
    it "complains about non-Hash args" do
      lambda { @builder.moves("herro") }.must raise_error(ArgumentError)
    end
    
    it "complains about Hashes that aren't pairs" do
      lambda { @builder.moves(:a => :b, :c => :d) }.must raise_error(ArgumentError)
    end
    
    it "makes sure that each specified state exists" do
      @builder.parent.should_receive(:state).once.with(:a)
      @builder.parent.should_receive(:state).once.with(:b)
      @builder.parent.should_receive(:state).once.with(:c)      
      @builder.moves([:a, :b] => :c)
    end
    
    it "adds transitions to the event" do
      @builder.parent.stub!(:state)     
      @builder.moves([:a, :b] => :c)
      @builder.event.transitions[:a].must == :c
      @builder.event.transitions[:b].must == :c
    end
  end
  
  describe "#stays" do
    it "is syntactic sugar for moves(:x => :x)" do
      @builder.parent.should_receive(:state).once.with(:a) 
      @builder.stays(:a)
      @builder.event.transitions[:a].must == :a
    end
  end
  
  describe "#apply" do
    it "instance evals a provided block" do
      @builder.parent.should_receive(:state).once.with(:a)
      @builder.apply { stays :a }
      @builder.event.transitions[:a].must == :a
    end
  end
end
