require_relative 'lib/ms_teams/version'

Gem::Specification.new do |spec|
  spec.name          = "ms_teams"
  spec.version       = MsTeams::VERSION
  spec.authors       = ["Kevin Chandler", "Jana Abumeri"]
  spec.email         = ["im.kevin@me.com", "jabumeri@uci.edu"]

  spec.summary       = %q{A lightweight Ruby gem to send actionable message cards to an Office 365 group (Microsoft Teams) }
  spec.homepage      = "https://github.com/shirts/microsoft-teams-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shirts/microsoft-teams-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/shirts/microsoft-teams-ruby/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.8"
  spec.add_development_dependency "rubocop"
end
