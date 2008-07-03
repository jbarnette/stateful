require File.expand_path("#{File.dirname(__FILE__)}/../helper")

require "stateful/listeners"

describe Stateful::Listeners do
  class Listeny; include Stateful::Listeners; end
  
  before :each do
    @listen = Listeny.new
  end
  
  describe "#listeners" do
    it "autovivifies a keyed list of listeners" do
      @listen.listeners[:asploded].must == []
    end
  end

  describe "#fire" do
    it "fires all listeners in order for a given key" do
      fired = []
      @listen.listeners[:asploded] << lambda { fired << 1 } << lambda { fired << 2 }

      @listen.fire(:asploded)
      fired.must == [1, 2]
    end
    
    it "passes all arguments along to the listeners" do
      args = []
      @listen.listeners[:x] << lambda { |*a| args = a }
      
      @listen.fire(:x, 1, 2, 3)
      args.must == [1, 2, 3]
    end
  end
end
