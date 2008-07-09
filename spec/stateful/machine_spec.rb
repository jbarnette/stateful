require File.expand_path("#{File.dirname(__FILE__)}/../helper")

require "stateful"

describe Stateful::Machine do
  before :each do
    @machine = Stateful::Machine.new
  end

  describe ".new" do
    it "starts with reasonable defaults" do
      @machine.start.must be_nil
      @machine.states.must == {}
      @machine.events.must == {}
    end
  end
  
  describe "#apply" do
    it "returns self" do
      @machine.apply.must equal(@machine)
    end

    it "optionally takes a start state" do
      @machine.apply(:start => :foo)
      @machine.start.must == :foo
    end
    
    describe "with a builder block" do
      it "can specify a start state" do
        @machine.apply { start :foo }
        @machine.start.must == :foo
      end
      
      it "can specify states" do
        @machine.apply { state :calm }
        @machine.states[:calm].must_not be_nil
      end
      
      it "can specify multiple states" do
        @machine.apply { states :calm, :bovine }
        @machine.states.size.must == 2
      end
      
      it "doesn't overwrite states that already exist" do
        @machine.apply { state :foo }
        foo = @machine.states[:foo]
        @machine.apply { state :foo }
        @machine.states[:foo].must equal(foo)
      end
      
      it "uses the first specified state as the start if there's no explicit start" do
        @machine.apply { state :foo }
        @machine.start.must == :foo
      end
      
      it "can specify events" do
        @machine.apply { on :activate }
        @machine.events[:activate].must_not be_nil
      end
      
      it "can specify event transitions" do
        @machine.apply do
          on :activate do
            move :inactive => :active
            stay :active, :hyper
          end
        end

        activate = @machine.events[:activate]
        activate.must_not be_nil
        
        activate.transitions.must == { :inactive => :active, :active => :active, :hyper => :hyper }
      end
      
      it "can build events incrementally" do
        @machine.apply do
          on :activate do
            move :inactive => :active
            stay :active
          end
        end
        
        activate = @machine.events[:activate]
        activate.transitions.size.must == 2
        
        @machine.apply { on(:activate) { stay :dormant } }
        activate.transitions.size.must == 3
      end
      
      it "can specify events available everywhere with :any" do
        @machine.apply do
          on :pause do
            move :active => :inactive
            move :any => :paused
          end
        end
        
        pause = @machine.events[:pause]
        pause.transitions.size.must == 2
        
        pause.transitions[:active].must == :inactive
        pause.transitions[:furious].must == :paused
      end
      
      sample_names = [:foo, :bar]
      sample_block = lambda {}
      
      [:entering, :entered, :exiting].each do |kind|
        it "can specify an '#{kind}' observer for a set of states" do
          @machine.apply { send(kind, *sample_names, &sample_block) }
          
          sample_names.each do |state|
            @machine.states[state].listeners[kind].must be_include(sample_block)
          end
        end
        
        it "can specify an '#{kind}' observer for all states" do
          @machine.apply { send(kind, &sample_block) }
          @machine.listeners[kind].must be_include(sample_block)
        end
      end

      [:firing, :fired].each do |kind|
        it "can specify an '#{kind}' observer for a set of events" do
          @machine.apply { send(kind, *sample_names, &sample_block) }
          
          sample_names.each do |event|
            @machine.events[event].listeners[kind].must be_include(sample_block)
          end
        end
        
        it "can specify an '#{kind}' observer for all events" do
          @machine.apply { send(kind, &sample_block) }
          @machine.listeners[kind].must be_include(sample_block)
        end
      end  
    end
  end
  
  describe "#accessorize" do
    before :each do
      @klass = Class.new
    end
    
    it "defines state? methods" do
      @machine.apply { state :haughty }
      @machine.accessorize(@klass)
      
      @klass.instance_methods.must include("haughty?")
    end
    
    it "doesn't trample existing state? methods" do
      @klass.send(:define_method, :haughty?) { true }
      
      @machine.apply { state :haughty }
      @machine.accessorize(@klass)

      @klass.new.must be_haughty
    end
    
    it "defines event! methods" do
      @machine.apply { on :castigate }
      @machine.accessorize(@klass)
      
      @klass.instance_methods.must include("castigate!")
    end
    
    it "doesn't trample existing event! methods" do
      @klass.send(:define_method, :castigate!) { "ohai" }
      
      @machine.apply { on :castigate }
      @machine.accessorize(@klass)

      @klass.new.castigate!.must == "ohai"
    end
  end
  
  describe "#execute" do
    it "complains about models that aren't stateful" do
      lambda {
        @machine.execute("thingy", :activate)
      }.must raise_error(Stateful::BadModel)
    end

    class AStatefulClass
      statefully do
        start :inactive
        
        on :activate do
          move :inactive => :active
        end
        
        on :deactivate do
          move :active => :inactive
        end
      end
    end
    
    before :each do
      @instance = AStatefulClass.new
    end
    
    it "complains about invalid events" do
      lambda {
        AStatefulClass.statefully.execute(@instance, :nonexistent_event)
      }.must raise_error(Stateful::EventNotFound)
    end

    it "complains about bad transitions" do
      lambda {
        AStatefulClass.statefully.execute(@instance, :deactivate)
      }.must raise_error(Stateful::BadTransition)
    end
    
    it "fires lifecycle events in the proper order" do
      steps = []
      
      AStatefulClass.statefully do
        firing { steps << :firing } 
        exiting { steps << :exiting }
        entering { steps << :entering }
        entered { steps << :entered }
        fired { steps << :fired }
      end
      
      @instance.current_state.must == :inactive
      
      AStatefulClass.statefully.execute(@instance, :activate)
      @instance.current_state.must == :active        
      steps.must == [:firing, :exiting, :entering, :entered, :fired] 
    end
    
    it "fires both global and state/event specific events" do
      global, specific = nil
      
      AStatefulClass.statefully do
        firing { |*args| global = args }
        firing(:activate) { |*args| specific = args }
      end
      
      AStatefulClass.statefully.execute(@instance, :activate)
      
      # model, event, to, from
      global.must == [@instance, :activate, :active, :inactive]
      specific.must == [@instance, :activate, :active, :inactive]
    end
  end

  require "fixtures/machines/campaign"

  describe "#to_dot" do
    # yes, this is a crap spec
    it "generates a dotfile" do
      machine = Fixtures::Campaign.statefully
      dots = machine.to_dot
      
      machine.events.each do |name, event|
        event.transitions.each do |from, to|
          dots.must =~ /#{from}->#{to}/
        end
      end
    end
  end
end
