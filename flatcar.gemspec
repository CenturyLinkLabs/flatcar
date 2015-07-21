require File.expand_path('../lib/flatcar/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = %w(CenturyLink)
  gem.email         = %w(ctl-labs-futuretech@ctl.io)
  gem.description   = 'A CLI for Ruby on Rails web applications to be deployed as containerized Docker services'
  gem.summary       = 'A CLI for Ruby on Rails web applications to be deployed as containerized Docker services'
  gem.homepage      = 'https://github.com/centurylinklabs/flatcar'
  gem.license       = 'Apache 2'
  gem.platform      = Gem::Platform::RUBY
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'flatcar'
  gem.require_paths = %w(lib)
  gem.version       = Flatcar::VERSION
  gem.required_ruby_version = '>= 2.2.2'
  # gem.add_dependency 'excon', '>= 0.27.4'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'simplecov', '~> 0.10.0'
  gem.add_development_dependency 'simplecov-rcov', '~> 0.2.3'
end
