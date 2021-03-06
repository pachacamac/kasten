# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kasten/version'

Gem::Specification.new do |spec|
  spec.name          = "kasten"
  spec.version       = Kasten::VERSION
  spec.authors       = ["pachacamac"]
  spec.email         = ["pachacamac@inboxalias.com"]

  spec.summary       = %q{Create a Kasten (German for box)}
  spec.description   = %q{Let users draw a Kasten (German for box) in an X environment and get its dimensions}
  spec.homepage      = "https://github.com/pachacamac/kasten"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.extensions    = ["ext/kasten/extconf.rb"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler"
end
