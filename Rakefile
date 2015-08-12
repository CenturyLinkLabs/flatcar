#!/usr/bin/env rake

require 'rake/clean'
require 'bundler/gem_tasks'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'

Rake::RDocTask.new do |rd|
  rd.main = 'README.md'
  rd.rdoc_files.include('README.md','lib/**/*.rb','bin/**/*')
  rd.title = 'Your application title'
end

spec = eval(File.read('flatcar.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end
