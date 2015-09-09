require File.join([File.dirname(__FILE__),'lib','flatcar','version.rb'])

Gem::Specification.new do |gem|
  gem.authors = %w(Michael Arnold, Laura Frank)
  gem.email = %w(hi@laura.is)
  gem.description = 'Flatcar is a command line tool to simplify the development of Ruby on Rails web applications that
                     are intended to be deployed and run in production as containerized Docker microservices.'
  gem.summary = 'A CLI for Ruby on Rails web applications to be deployed as containerized Docker services'
  gem.homepage = 'https://github.com/flatcar/flatcar'
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
  gem.add_dependency 'gli', '2.13.1'
  gem.add_dependency 'rails', '~> 4.2'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'simplecov', '~> 0.10.0'
  gem.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
  gem.add_development_dependency 'rdoc', '~> 4.2'
end
