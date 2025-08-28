# frozen_string_literal: true

require_relative "lib/browserslist/version"

Gem::Specification.new do |spec|
  spec.name = "browserslist"
  spec.version = Browserslist::VERSION
  spec.authors = ["hschne"]
  spec.email = ["hello@hansschnedlitz.com"]

  spec.summary = "Bring browserslist to Ruby"
  spec.description = "Bring browserslist to Ruby. Use your existing browserslist config and convert it to a Ruby hash for use with Rails allowed browsers or other browser support detection."
  spec.homepage = "https://github.com/hschne/browserslist-rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/hschne/browserslist-rb"
  spec.metadata["changelog_uri"] = "https://github.com/hschne/browserslist-rb/blob/main/CHANGELOG.md"

  spec.files = %w[
    README.md
    LICENSE.txt
    CHANGELOG.md
    CODE_OF_CONDUCT.md
    exe/browserslist
  ] + Dir["lib/**/*.rb"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
