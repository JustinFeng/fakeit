lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fakeit/version'

Gem::Specification.new do |spec|
  spec.name          = 'fakeit'
  spec.version       = Fakeit::VERSION
  spec.authors       = ['Justin Feng']
  spec.email         = ['realfengjia@foxmail.com']

  spec.summary       = 'Create mock server from Openapi specification'
  spec.description   = 'Create mock server from Openapi specification'
  spec.homepage      = 'https://github.com/JustinFeng/fakeit'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = 'fakeit'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 11.0'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.67'
  spec.add_development_dependency 'simplecov', '~> 0.16'

  spec.add_dependency 'faker', '~> 1.9'
  spec.add_dependency 'openapi_parser', '0.2.4'
  spec.add_dependency 'rack', '~> 2.0'
  spec.add_dependency 'slop', '~> 4.6'
end
