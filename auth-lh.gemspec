# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auth/lh/version'

Gem::Specification.new do |s|
  s.name          = "auth-lh"
  s.version       = Auth::Lh::VERSION
  s.authors       = ["Matias Hick"]
  s.email         = ["unformatt@gmail.com"]
  s.description   = "Authentication with auth lh api"
  s.summary       = "Authentication with auth lh api"
  s.homepage      = "https://github.com/unformattmh/auth-lh"
  s.license       = "MIT"

  s.files         = Dir["LICENSE.md", "README.md", "CHANGELOG.md", "lib/**/*"]
  s.executables   = []
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", ">= 1.3"
  s.add_development_dependency "rake"

  s.add_runtime_dependency "rest-client", ">= 1.6.7"
end
