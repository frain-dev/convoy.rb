require_relative 'lib/convoy/version'

Gem::Specification.new do |spec|
  spec.name          = "convoy.rb"
  spec.version       = Convoy::VERSION
  spec.authors       = ["Subomi Oluwalana"]
  spec.email         = ["subomioluwalana71@gmail.com"]

  spec.summary       = "Convoy Ruby Client."
  spec.description   = "Convoy ruby client to push webhook events from any ruby application."
  spec.homepage      = "https://getconvoy.io"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/frain-dev/convoy.rb"
  spec.metadata["changelog_uri"] = "https://github.com/frain-dev/convoy.rb/blob/main/CHANGELOG"

  spec.add_runtime_dependency 'zeitwerk', '~> 2.5'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

end
