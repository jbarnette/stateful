require "date"
require "fileutils"
require "rubygems"
require "rake/gempackagetask"
require "spec/rake/spectask"

require "./lib/stateful/version.rb"

module Rakefile
  def self.windows?
    /djgpp|(cyg|ms|bcc)win|mingw/ =~ RUBY_PLATFORM
  end
end

stateful_gemspec = Gem::Specification.new do |s|
  s.name              = "stateful"
  s.rubyforge_project = "stateful"
  s.version           = Stateful::VERSION
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.rdoc"]
  s.summary           = "Make your Ruby objects stately."
  s.description       = s.summary
  s.author            = "John Barnette"
  s.email             = "jbarnette@rubyforge.org"
  s.homepage          = "http://github.com/jbarnette/stateful"
  s.require_path      = "lib"
  s.files             = %w(README.rdoc Rakefile) + Dir.glob("{lib,spec}/**/*")
end

Rake::GemPackageTask.new(stateful_gemspec) do |pkg|
  pkg.gem_spec = stateful_gemspec
end

namespace :gem do
  desc "Build and install as a RubyGem"
  task :install => :package do
    sh %{#{'sudo' unless Rakefile.windows?} gem install --local pkg/stateful-#{Stateful::VERSION}}
  end
  
  desc "Generate stateful.gemspec"
  task :spec do
    File.open("stateful.gemspec", "w") do |f|
      f.puts(stateful_gemspec.to_ruby)
    end
  end
end

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts = ["--options", "spec/spec.opts"]
end

task :default => :spec

desc "Keep things tidy"
task :clean => :clobber_package
