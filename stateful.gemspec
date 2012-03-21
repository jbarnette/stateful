# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["John Barnette"]
  gem.email         = ["john@jbarnette.com"]
  gem.description   = "A simple state machine mixin."
  gem.summary       = "Give an object or class stateful behavior."
  gem.homepage      = "https://github.com/jbarnette/stateful"

  gem.files         = `git ls-files`.split "\n"
  gem.test_files    = gem.files.grep /test\//
  gem.name          = "stateful"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.0"

  gem.add_dependency "watchable", "~> 0.0"

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"
end
