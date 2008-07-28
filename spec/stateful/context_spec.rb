require File.expand_path("#{File.dirname(__FILE__)}/../helper")

require "stateful"

describe Stateful::Context do
  it "has model, event, to, from, and extras" do
    ctx = Stateful::Context.new(:model, :event, :to, :from, :extras)
    ctx.model.must == :model
    ctx.event.must == :event
    ctx.to.must == :to
    ctx.from.must == :from
    ctx.extras.must == :extras
  end
end
