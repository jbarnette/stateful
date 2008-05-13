module Stateful #:nodoc:
  module Listeners #:nodoc:
    def listeners(kind)
      @listeners ||= Hash.new { |h,k| h[k] = [] }
      @listeners[kind]
    end
    
    def fire(kind, *args)
      listeners(kind).each { |l| l.call(*args) }
    end
  end
end
