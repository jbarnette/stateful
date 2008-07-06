$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))

require "spec"

module Spec::Expectations::ObjectExpectations
  # all conditionals are to make autotest happy
  alias_method :must, :should unless defined?(must)
  alias_method :must_not, :should_not unless defined?(must_not)
  undef_method :should if defined?(should)
  undef_method :should_not if defined?(should_not)
end

require "stateful"
require "#{File.dirname(__FILE__)}/fixtures/campaign"
