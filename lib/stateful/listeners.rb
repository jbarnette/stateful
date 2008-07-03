module Stateful #:nodoc:
  module Listeners #:nodoc:
    def listeners
      @listeners ||= Hash.new { |h,k| h[k] = [] }
    end
    
    def fire(kind, *args)
      listeners[kind].each { |l| l[*args] }
    end
  end
end
