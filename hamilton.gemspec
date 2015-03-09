# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamilton/version'

Gem::Specification.new do |spec|
  spec.name          = "hamilton"
  spec.version       = Hamilton::VERSION
  spec.authors       = ["Takashi Kokubun"]
  spec.email         = ["takashikkbn@gmail.com"]
  spec.summary       = %q{Yet another haml implementation}
  spec.description   = %q{Yet another haml implementation}
  spec.homepage      = "https://github.com/k0kubun/hamilton"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "haml"
  spec.add_development_dependency "slim"
  spec.add_development_dependency "erubis"
end
