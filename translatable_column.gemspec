# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "translatable_column/version"

Gem::Specification.new do |spec|
  spec.name          = "translatable_column"
  spec.version       = TranslatableColumn::VERSION
  spec.authors       = ["Claessens Simon"]
  spec.email         = ["gagalago@gmail.com"]

  spec.summary       = %q{translate database fields on rails model}
  spec.homepage      = "https://github.com/sortlist/translatable_column"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "activesupport", ">= 4.0"
  spec.add_dependency "activerecord", ">= 4.0"
end
