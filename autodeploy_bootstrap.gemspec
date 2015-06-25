# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'autodeploy_bootstrap/version'

Gem::Specification.new do |spec|
  spec.name          = "autodeploy_bootstrap"
  spec.version       = AutodeployBootstrap::VERSION
  spec.authors       = ["Jonathan Colby"]
  spec.email         = ["jcolby@team.mobile.de"]
  spec.summary       = %q{A bootstrap client for the autodeploy deployment system}
  spec.description   = %q{This client program can be used to bootstrap the application(s) which should be installed on a host, according to the metadata in Autodeploy. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "dm-mysql-adapter"
  spec.add_dependency "data_mapper"
  spec.add_dependency "nokogiri"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.7"
end
