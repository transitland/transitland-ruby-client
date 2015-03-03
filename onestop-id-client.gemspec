# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'onestop_id_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'onestop-id-client'
  spec.version       = OnestopIdClient::VERSION
  spec.authors       = ['Drew Dara-Abrams']
  spec.email         = ['drew@mapzen.com']
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = 'https://github.com/transitland/onestop-id-ruby-client'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split('\x0')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.0'

  spec.add_dependency 'virtus', '~> 1.0'
  spec.add_dependency 'git', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'webmock', '~> 1.20'
  spec.add_development_dependency 'simplecov', '~> 0.9'

  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'byebug', '~> 3.5'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
end
