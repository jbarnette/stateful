require File.expand_path(File.dirname(__FILE__) + "/../helper")

module Stateful
  class MachineTest < Test::Unit::TestCase
    def setup
      @machine = Stateful::Machine.new      
    end

    def test_update_returns_self
      assert_same(@machine, @machine.update)
    end
    
    def test_update_optionally_takes_start
      @machine.update(:start => :foo)
      assert_equal(:foo, @machine.start)
    end
    
    def test_update_block_can_specify_start
      @machine.update { start :foo }
      assert_equal(:foo, @machine.start)
    end
    
    def test_update_block_can_specify_states
      assert_equal({}, @machine.states)
      @machine.update { state :calm }
      assert_not_nil(@machine.states[:calm])
    end
    
    def test_update_block_can_specify_multiple_states
      assert_equal({}, @machine.states)
      @machine.update { states :calm, :bovine }
      assert_equal(2, @machine.states.size)
    end
    
    def test_update_block_states_do_not_overwrite
      @machine.update { state :foo }
      foo = @machine.states[:foo]
      @machine.update { state :foo }
      assert_same(foo, @machine.states[:foo])
    end
    
    def test_update_block_first_state_specified_becomes_start
      assert_nil(@machine.start)
      @machine.update { state :foo }
      assert_equal(:foo, @machine.start)
      @machine.update { state :bar }
      assert_equal(:foo, @machine.start)
    end
    
    def test_update_block_can_specify_events
      assert_equal({}, @machine.events)
      @machine.update { event :activate }
      assert_not_nil(@machine.events[:activate])
    end
    
    def test_update_event_block_can_specify_transitions
      @machine.update do
        event :activate do
          moves :inactive => :active
          stays :active, :hyper
        end
      end
      
      activate = @machine.events[:activate]
      assert_not_nil(activate)
      
      assert_equal({:inactive => :active, :active => :active, :hyper => :hyper }, activate.transitions)
    end
    
    def test_update_event_blocks_are_additive
      @machine.update do
        event :activate do
          moves :inactive => :active
          stays :active
        end
      end
      
      activate = @machine.events[:activate]
      assert_equal(2, activate.transitions.size)
      
      @machine.update { event(:activate) { stays :dormant } }
      assert_equal(3, activate.transitions.size)
    end
    
    def test_update_event_blocks_moves_complains_about_bad_pairs
      assert_raise(ArgumentError) do
        @machine.update do
          event :activate do
            moves :active => :inactive, :somnolent => :febrile
          end
        end
      end
    end
    
    def test_update_event_blocks_moves_handles_multiple_start_states
      @machine.update do
        event :activate do
          moves [:inactive, :active] => :active
        end
      end
      
      activate = @machine.events[:activate]
      assert_equal(2, activate.transitions.size)
    end

    [:entering, :entered, :exiting].each do |kind|
      class_eval <<-END, __FILE__, __LINE__
        def test_update_block_state_#{kind}_listener
          nothing = lambda {}
          names = [:foo, :bar]
          
          @machine.update do
            #{kind}(*names, &nothing)
          end
          
          names.each do |name|
            assert(@machine.states[name].listeners(#{kind.inspect}).include?(nothing))
          end
        end
        
        def test_update_block_global_state_#{kind}_listener
          @machine.update { #{kind} {} }
          assert_equal(1, @machine.listeners(#{kind.inspect}).size)
        end
      END
    end

    [:firing, :fired].each do |kind|
      class_eval <<-END, __FILE__, __LINE__
        def test_update_block_event_#{kind}_listener
          nothing = lambda {}
          names = [:foo, :bar]
          
          @machine.update do
            #{kind}(*names, &nothing)
          end
          
          names.each do |name|
            assert(@machine.events[name].listeners(#{kind.inspect}).include?(nothing))
          end
        end
        
        def test_update_block_global_state_#{kind}_listener
          @machine.update { #{kind} {} }
          assert_equal(1, @machine.listeners(#{kind.inspect}).size)
        end
      END
    end
    
    def test_case_name
      
    end
  end
end
