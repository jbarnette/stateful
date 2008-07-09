require "stateful/version"
require "stateful/errors"
require "stateful/machine"
require "stateful/state"
require "stateful/event"

require "stateful/persisters"

require "stateful/tracing"

class Class
  def statefully(options={}, &block)
    unless stateful?
      persister = Stateful::Persisters.for(self)
      @machine = Stateful::Machine.new(persister)
    end

    return @machine if options.empty? && !block_given?
    @machine.apply(options, &block).accessorize(self)
  end

  def stateful?
    defined?(@machine)
  end
end
