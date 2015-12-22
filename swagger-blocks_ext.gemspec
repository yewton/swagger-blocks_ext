# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swagger/blocks_ext/version'

Gem::Specification.new do |spec|
  spec.name          = "swagger-blocks_ext"
  spec.version       = Swagger::BlocksExt::VERSION
  spec.authors       = ["yewton"]
  spec.email         = ["yewton@gmail.com"]

  spec.summary       = %q{Some extensions for swagger-blocks}
  spec.description   = %q{Some extensions for swagger-blocks}
  spec.homepage      = "https://github.com/yewton/swagger-blocks_ext"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "swagger-blocks", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
