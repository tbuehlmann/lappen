lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lappen/version'

Gem::Specification.new do |spec|
  spec.name          = 'lappen'
  spec.version       = Lappen::VERSION
  spec.authors       = ['Tobias Bühlmann']
  spec.email         = ['tobias@xn--bhlmann-n2a.de']
  spec.summary       = 'Relation filtering abstraction library for Rails.'
  spec.homepage      = 'https://github.com/tbuehlmann/lappen'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = []
  spec.test_files    = spec.files.grep(/\Aspec/)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_runtime_dependency 'railties',      '>= 4.0', '< 5.1'
  spec.add_runtime_dependency 'activesupport', '>= 4.0', '< 5.1'
  spec.add_runtime_dependency 'request_store'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-stack_explorer'
  spec.add_development_dependency 'actionpack', '~> 4.0'
  spec.add_development_dependency 'activerecord', '~> 4.0'
  spec.add_development_dependency 'sqlite3'
end
