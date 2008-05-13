require "stateful/version"
require "stateful/errors"
require "stateful/machine"
require "stateful/state"
require "stateful/event"
require "stateful/support"

class Class
  def statefully(options={}, &block)
    include Stateful::Support unless self < Stateful::Support
    state_machine.update(options, &block)
  end
end
