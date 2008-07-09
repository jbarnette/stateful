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
      @machine = Stateful::Machine.new
      Stateful::Persisters.decorate(self)
    end

    return @machine if options.empty? && !block_given?
    @machine.apply(options, &block).accessorize(self)
  end

  def stateful?
    defined?(@machine)
  end
end
