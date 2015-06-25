# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hario/version'

Gem::Specification.new do |spec|
  spec.name          = "hario"
  spec.version       = Hario::VERSION
  spec.authors       = ["Mike Campbell"]
  spec.email         = ["mike@wordofmike.net"]
  spec.summary       = %q{Hario provides ActiveRecord filtering for Rails APIs.}
  spec.homepage      = "https://github.com/meritec/hario"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3"
end
