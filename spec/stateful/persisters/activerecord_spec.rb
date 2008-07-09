require File.expand_path("#{File.dirname(__FILE__)}/../../helper")

require "stateful/persisters/activerecord"

if %w(activerecord sqlite3-ruby).all? { |g| Gem.available?(g) }
  describe Stateful::Persisters::ActiveRecord do
    
  end
end
