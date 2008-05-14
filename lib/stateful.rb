require "stateful/version"
require "stateful/errors"
require "stateful/machine"
require "stateful/state"
require "stateful/event"
require "stateful/persisters/default"

class Class
  def statefully(options={}, &block)
    unless stateful?
      @stateful = Stateful::Machine.new
      include Stateful::Persisters::Default
    end

    return @stateful if options.empty? && !block_given?    

    @stateful.apply(options, &block)
    @stateful.accessorize(self)
    @stateful
  end
  
  def stateful?
    defined? @stateful
  end
end
