Gem::Specification.new do |s|
  s.name = %q{stateful}
  s.version = "1.0.0.200807060249"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette"]
  s.date = %q{2008-07-06}
  s.description = %q{Make your Ruby objects stately.}
  s.email = %q{jbarnette@rubyforge.org}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "Rakefile", "lib/stateful", "lib/stateful/builders", "lib/stateful/builders/event.rb", "lib/stateful/builders/event.rbc", "lib/stateful/builders/machine.rb", "lib/stateful/builders/machine.rbc", "lib/stateful/errors.rb", "lib/stateful/errors.rbc", "lib/stateful/event.rb", "lib/stateful/event.rbc", "lib/stateful/listeners.rb", "lib/stateful/listeners.rbc", "lib/stateful/machine.rb", "lib/stateful/machine.rbc", "lib/stateful/persisters", "lib/stateful/persisters/default.rb", "lib/stateful/persisters/default.rbc", "lib/stateful/state.rb", "lib/stateful/state.rbc", "lib/stateful/tracing.rb", "lib/stateful/tracing.rbc", "lib/stateful/version.rb", "lib/stateful/version.rbc", "lib/stateful.rb", "lib/stateful.rbc", "spec/fixtures", "spec/fixtures/campaign.rb", "spec/helper.rb", "spec/helper.rbc", "spec/spec.opts", "spec/stateful", "spec/stateful/builders", "spec/stateful/builders/event_spec.rb", "spec/stateful/builders/event_spec.rbc", "spec/stateful/builders/machine_spec.rb", "spec/stateful/builders/machine_spec.rbc", "spec/stateful/event_spec.rb", "spec/stateful/event_spec.rbc", "spec/stateful/listeners_spec.rb", "spec/stateful/listeners_spec.rbc", "spec/stateful/machine_spec.rb", "spec/stateful/machine_spec.rbc", "spec/stateful/tracing_spec.rb", "spec/stateful/tracing_spec.rbc"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jbarnette/stateful}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{stateful}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Make your Ruby objects stately.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
