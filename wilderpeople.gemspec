# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wilderpeople/version'

Gem::Specification.new do |spec|
  spec.name          = "wilderpeople"
  spec.version       = Wilderpeople::VERSION
  spec.authors       = ["Rob Nichols"]
  spec.email         = ["robnichols@warwickshire.gov.uk"]

  spec.summary       = %q{A tool for fuzzy matching people data}
  spec.description   = %q{Allow people data from one source to be compared with anothe source}
  spec.homepage      = "https://github.com/reggieb/wilderpeople"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'hypocorism', "~> 0.0.2"
  spec.add_dependency 'levenshtein'
  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
