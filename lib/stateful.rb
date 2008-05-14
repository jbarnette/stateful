require "stateful/version"
require "stateful/errors"
require "stateful/machine"
require "stateful/state"
require "stateful/event"
require "stateful/support"

class Class
  def statefully(options={}, &block)
    include Stateful::Support unless self < Stateful::Support

    @machine ||= Stateful::Machine.new
    return @machine if options.empty? && !block_given?    

    @machine.apply(options, &block)
    @machine.accessorize(self)
    @machine
  end
end
