# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "claudius"
  spec.version       = "0.0.3"
  spec.authors       = ["radk0s", "blost"]
  spec.email         = ["rachamot@gmail.com"]
  spec.description   = "Write a gem description"
  spec.summary       = "Write a gem summary"
  spec.homepage      = "https://github.com/blostic/claudius"
  spec.license       = "MIT"
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib/tree_building","lib/remote_execution"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "fog", ">= 1.22.0"
  spec.add_runtime_dependency "net-ssh", "2.9.1"
  spec.add_runtime_dependency "graph", "2.7.0"
  spec.add_runtime_dependency "awesome_print", "1.2.0"
end
