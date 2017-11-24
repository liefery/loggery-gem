# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loggery/gem/version'

Gem::Specification.new do |spec|
  spec.name          = "loggery-gem"
  spec.version       = Loggery::Gem::VERSION
  spec.authors       = ["Simon Stemplinger"]
  spec.email         = ["simon@stem.ps"]

  spec.summary       = %q{Generate logstash compatible log output from Rails apps.}
  spec.homepage      = "https://github.com/liefery/loggery-gem"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
