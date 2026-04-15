require_relative "lib/shipwright/version"

Gem::Specification.new do |spec|
  spec.name        = "shipwright"
  spec.version     = Shipwright::VERSION
  spec.authors     = ["Headway"]
  spec.homepage    = "https://github.com/headwayio/shipwright-rails"
  spec.summary     = "Headway design system as Rails ViewComponents with Tailwind 4 tokens"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,lib}/**/*", "CHANGELOG.md", "Rakefile"]
  end

  spec.add_dependency "rails", ">= 8.1"
  spec.add_dependency "view_component", ">= 3.0"
  spec.add_dependency "tailwindcss-rails", ">= 4.0"
  spec.add_dependency "tailwind_merge", "~> 1.4"
end
