# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yapt/version'

Gem::Specification.new do |spec|
  spec.name          = "yapt"
  spec.version       = Yapt::VERSION
  spec.authors       = ["Sam Schenkman-Moore"]
  spec.email         = ["samsm@samsm.com"]
  spec.description   = %q{A command line app for navigating Pivotal Tracker. WIP}
  spec.summary       = %q{Command line pivotal tracker thing. WIP}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency    'boson'
  spec.add_dependency    'highline'
  spec.add_dependency    'rest-client'
  spec.add_dependency    'chronic'
  spec.add_dependency    'rainbow'
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
