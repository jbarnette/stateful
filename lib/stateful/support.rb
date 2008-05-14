module Stateful
  module Support
    attr_writer :current_state

    def current_state
      @current_state ||= self.class.statefully.start
    end
  end
end
