= Stateful Objects for Ruby

== Example

  class AClass
  
    # :start is optional, defaults to first state declared    
    statefully(:start => :foo) do
    
      # can declare a bunch of states like this,
      states :foo, :bar, :baz, :bax
    
      # or one at a time
      state :angry
      state :angsty

      # note that you don't have to declare states at all if you don't want to:
      # they'll be auto-created when events (or the machine's start) refer to them.
    
      event :traffic do
        # an event must specify all the places it can be called. it can put
        # them in a 'changes' line, like this,
        changes :state_or_list => :dest
      
        # or it can specify that the event 'cycles', staying in the originating state
        stays :state_or_list
      end
    end
  end

  # multiple 'statefully' blocks are totally okay.
  # you can even add them from outside the class!

  AClass.statefully do
  
    # you can listen for attempted state entry. Stateful will provide your
    # block with the model that's changing state, the destination state,
    # and the previous state (if any).
  
    # all the block params are optional. your block can take no arguments
    # if that sproings your winkie.
  
    entering :state_or_list do |model, to, from|
      # do some ruby stuff! Exceptions thrown in here will
      # keep the transition from occuring, i.e., the model's
      # current state will still be 'from'.
    end
  
    # you can also listen for successful state entry. same optional block
    # params are available.
  
    entered :state_or_list do |model, to, from|
      # more ruby stuff! You can throw exceptions in here, of course,
      # but it won't change the model's current state.
    end
  
    # listening for attempted state exit is just like state entry,
    # but the destination state is provided instead of the source.
  
    exiting :state_or_list do |model, to, from|
      # awesome ruby stuff! throwing exceptions in here vetoes
      # the transition.
    end
  end

  AClass.statefully do
  
    # it's possible to listen to events fire, too!
  
    firing :event_or_list do |model, event, to, from|
      # throwing exceptions here will veto the transition
    end
  
    # or after they've successfully fired

    fired :event_or_list do |model, event, to, from|
      # throwing here does squat
    end
  end

  # The order of listeners/events: anything marked with an 'if' can
  # be vetoed by throwing an exception.

  # (an event is triggered, e.g., model.finish!)
  #   - if all matching 'event firing'
  #     - if all matching 'state exiting'
  #       - if all matching 'state entering'
  #         - STATE CHANGE PERSISTED
  #         - all matching 'state entered'
  #         - all matching 'event fired'

  # calls to 'statefully' always return the Stateful::StateMachine instance
  # for the class, so reflection is pretty easy.

  sm = AClass.statefully
  states = sm.states # instances of Stateful::State

  sm.valid? :foo => :bar # => false, or whatever

  # If the target model class is a descendant of ActiveRecord::Base,
  # Statefully will automatically mix in a DB-aware persister.
  # otherwise, it's just an attr_accessor called 'current_state'.

  # Want to see what's going on?
  # include Stateful::Tracing
  #
  # it'll use the Rails logging bits if they're around, etc, etc.
  
  # Need to audit your state changes?
  # include Stateful::Timestamps
  #
  # it'll set attributes for state_at and event_fired_at if respond_to?

  # On any of the state (entering, entered, exiting) or event (firing, fired)
  # listeners, not providing a state or event list means you'll hear about 'em all.

  AClass.statefully do
    entering { }
    entered { }
    exiting { }
    firing { } 
    fired { } 
  end

== Install

  sudo gem install stateful

== License

(The MIT License)

Copyright (c) 2008 John Barnette

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
