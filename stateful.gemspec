# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stateful}
  s.version = "1.0.0.200812261315"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette"]
  s.date = %q{2008-12-26}
  s.description = %q{Make your Ruby objects stately.}
  s.email = %q{jbarnette@rubyforge.org}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/stateful", "lib/stateful/builders", "lib/stateful/builders/event.rb", "lib/stateful/builders/machine.rb", "lib/stateful/context.rb", "lib/stateful/errors.rb", "lib/stateful/event.rb", "lib/stateful/listeners.rb", "lib/stateful/machine.rb", "lib/stateful/persisters", "lib/stateful/persisters/activerecord.rb", "lib/stateful/persisters/attribute.rb", "lib/stateful/persisters/default.rb", "lib/stateful/persisters.rb", "lib/stateful/state.rb", "lib/stateful/tracing.rb", "lib/stateful/version.rb", "lib/stateful.rb", "spec/fixtures", "spec/fixtures/activerecord", "spec/fixtures/activerecord/model.rb", "spec/fixtures/activerecord/schema.rb", "spec/fixtures/machines", "spec/fixtures/machines/campaign.rb", "spec/helper.rb", "spec/spec.opts", "spec/stateful", "spec/stateful/builders", "spec/stateful/builders/event_spec.rb", "spec/stateful/builders/machine_spec.rb", "spec/stateful/context_spec.rb", "spec/stateful/event_spec.rb", "spec/stateful/listeners_spec.rb", "spec/stateful/machine_spec.rb", "spec/stateful/persisters", "spec/stateful/persisters/activerecord_spec.rb", "spec/stateful/tracing_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jbarnette/stateful}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{stateful}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Make your Ruby objects stately.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
