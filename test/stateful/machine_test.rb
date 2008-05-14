require File.expand_path(File.dirname(__FILE__) + "/../helper")

module Stateful
  class MachineTest < Test::Unit::TestCase
    def setup
      @machine = Stateful::Machine.new
    end

    def test_apply_returns_self
      assert_same(@machine, @machine.apply)
    end
    
    def test_apply_optionally_takes_start
      @machine.apply(:start => :foo)
      assert_equal(:foo, @machine.start)
      assert_equal(1, @machine.states.size)
    end
    
    def test_apply_block_can_specify_start
      @machine.apply { start :foo }
      assert_equal(:foo, @machine.start)
      assert_equal(1, @machine.states.size)
    end
    
    def test_apply_block_can_specify_states
      assert_equal({}, @machine.states)
      @machine.apply { state :calm }
      assert_not_nil(@machine.states[:calm])
    end
    
    def test_apply_block_can_specify_multiple_states
      assert_equal({}, @machine.states)
      @machine.apply { states :calm, :bovine }
      assert_equal(2, @machine.states.size)
    end
    
    def test_apply_block_states_do_not_overwrite
      @machine.apply { state :foo }
      foo = @machine.states[:foo]
      @machine.apply { state :foo }
      assert_same(foo, @machine.states[:foo])
    end
    
    def test_apply_block_first_state_specified_becomes_start
      assert_nil(@machine.start)
      @machine.apply { state :foo }
      assert_equal(:foo, @machine.start)
      @machine.apply { state :bar }
      assert_equal(:foo, @machine.start)
    end
    
    def test_apply_block_can_specify_events
      assert_equal({}, @machine.events)
      @machine.apply { event :activate }
      assert_not_nil(@machine.events[:activate])
    end
    
    def test_apply_event_block_can_specify_transitions
      @machine.apply do
        event :activate do
          changes :inactive => :active
          stays :active, :hyper
        end
      end
      
      activate = @machine.events[:activate]
      assert_not_nil(activate)
      
      assert_equal({:inactive => :active, :active => :active, :hyper => :hyper }, activate.transitions)
    end
    
    def test_apply_event_blocks_are_additive
      @machine.apply do
        event :activate do
          changes :inactive => :active
          stays :active
        end
      end
      
      activate = @machine.events[:activate]
      assert_equal(2, activate.transitions.size)
      
      @machine.apply { event(:activate) { stays :dormant } }
      assert_equal(3, activate.transitions.size)
    end
    
    def test_apply_event_blocks_changes_complains_about_bad_pairs
      assert_raise(ArgumentError) do
        @machine.apply do
          event :activate do
            changes :active => :inactive, :somnolent => :febrile
          end
        end
      end
    end
    
    def test_apply_event_blocks_changes_handles_multiple_from_states
      @machine.apply do
        event :activate do
          changes [:inactive, :active] => :active
        end
      end
      
      activate = @machine.events[:activate]
      assert_equal(2, activate.transitions.size)
    end

    def test_event_block_transitions_autovivify_states
      @machine.apply do
        event :activate do
          changes :inactive => :active
        end
      end
      
      assert_equal(2, @machine.states.size)
    end

    [:entering, :entered, :exiting].each do |kind|
      class_eval <<-END, __FILE__, __LINE__
        def test_apply_block_state_#{kind}_listener
          nothing = lambda {}
          names = [:foo, :bar]
          
          @machine.apply do
            #{kind}(*names, &nothing)
          end
          
          names.each do |name|
            assert(@machine.states[name].listeners(#{kind.inspect}).include?(nothing))
          end
        end
        
        def test_apply_block_global_state_#{kind}_listener
          @machine.apply { #{kind} {} }
          assert_equal(1, @machine.listeners(#{kind.inspect}).size)
        end
      END
    end

    [:firing, :fired].each do |kind|
      class_eval <<-END, __FILE__, __LINE__
        def test_apply_block_event_#{kind}_listener
          nothing = lambda {}
          names = [:foo, :bar]
          
          @machine.apply do
            #{kind}(*names, &nothing)
          end
          
          names.each do |name|
            assert(@machine.events[name].listeners(#{kind.inspect}).include?(nothing))
          end
        end
        
        def test_apply_block_global_state_#{kind}_listener
          @machine.apply { #{kind} {} }
          assert_equal(1, @machine.listeners(#{kind.inspect}).size)
        end
      END
    end
    
    def test_execute_complains_about_non_stateful_models
      assert_raise(Stateful::BadModel) { @machine.execute("thingy", :activate) }
    end
    
    class AStatefulClass
      statefully do
        start :inactive
        
        event :activate do
          changes :inactive => :active
        end
        
        event :deactivate do
          changes :active => :inactive
        end
      end
    end
    
    def test_execute_complains_about_missing_events
      assert_raise(Stateful::EventNotFound) do
        AStatefulClass.statefully.execute(AStatefulClass.new, :destroy)
      end
    end
    
    def test_execute_complains_about_bad_transitions
      assert_raise(Stateful::BadTransition) do
        AStatefulClass.statefully.execute(AStatefulClass.new, :deactivate)
      end
    end
    
    def test_execute_lifecycle
      steps = []
      
      machine = AStatefulClass.statefully do
        firing { steps << :firing } 
        exiting { steps << :exiting }
        entering { steps << :entering }
        entered { steps << :entered }
        fired { steps << :fired }
      end
      
      model = AStatefulClass.new
      assert_equal(:inactive, model.current_state)      
      
      machine.execute(model, :activate)
      assert_equal(:active, model.current_state)
      
      assert_equal([:firing, :exiting, :entering, :entered, :fired], steps)
    end
    
    def test_firing
      global, specific = nil
      
      machine = AStatefulClass.statefully do
        firing { |*args| global = args }
        firing(:activate) { |*args| specific = args }
      end
      
      model = AStatefulClass.new
      machine.execute(model, :activate)
      
      # model, event, to, from
      assert_equal([model, :activate, :active, :inactive], global)
      assert_equal([model, :activate, :active, :inactive], specific)
    end

    def test_instance_helpers
      model = AStatefulClass.new
      
      assert(model.inactive?)
      assert(!model.active?)
      
      model.activate!
      assert(!model.inactive?)
      assert(model.active?)
    end
  end
end
