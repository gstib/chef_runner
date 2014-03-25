# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chef_runner/version'

Gem::Specification.new do |spec|
  spec.name          = 'chef_runner'
  spec.version       = ChefRunner::VERSION
  spec.authors       = ['Grant Tibbey']
  spec.email         = ['granttibbey@hotmail.com']
  spec.summary       = %q{Gem to install Chef recipes remotely without a Chef server}
  spec.description   = %q{Gem to install Chef recipes remotely without a Chef server}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency('thor', '~> 0.19')
  spec.add_runtime_dependency('sshkit', '~> 1.3')

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
