lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'structured_menus/version'

Gem::Specification.new do |spec|
  spec.name          = 'structured_menus'
  spec.version       = StructuredMenus::VERSION
  spec.authors       = ['ArtOfCode-']
  spec.email         = ['hello@artofcode.co.uk']

  spec.summary       = 'An easy way to create flexible menus of things for Rails apps.'
  spec.homepage      = 'https://github.com/ArtOfCode-/structured_menus'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'rails', '~> 5'
end
