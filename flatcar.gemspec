require File.join([File.dirname(__FILE__),'lib','flatcar','version.rb'])

Gem::Specification.new do |gem|
  gem.authors = %w(CenturyLink)
  gem.email = %w(ctl-labs-futuretech@ctl.io)
  gem.description = 'A CLI for Ruby on Rails web applications to be deployed as containerized Docker services'
  gem.summary = 'A CLI for Ruby on Rails web applications to be deployed as containerized Docker services'
  gem.homepage = 'https://github.com/centurylinklabs/flatcar'
  gem.license = 'Apache 2'
  gem.platform = Gem::Platform::RUBY
  gem.files = `git ls-files`.split($\)
  gem.executables << 'flatcar'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = 'flatcar'
  gem.require_paths << 'lib'
  gem.version = Flatcar::VERSION
  gem.has_rdoc = true
  gem.extra_rdoc_files = ['flatcar.rdoc']
  gem.rdoc_options << '--title' << 'flatcar' << '--main' << 'README.md' << '-ri'
  gem.bindir = 'bin'
  gem.required_ruby_version = '>= 2.2.2'
  gem.add_dependency 'rails', '~> 4.2'
  gem.add_development_dependency('rake')
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'simplecov', '~> 0.10.0'
  gem.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
  gem.add_development_dependency('rdoc')
  gem.add_runtime_dependency('gli','2.13.1')
end
