module Stateful
  module Tracing
    def self.included(base)
      base.statefully do
        firing   {}
        exiting  {}
        entering {}
        entered  {}
        fired    {}
      end
    end
  end
end
