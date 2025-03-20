# -*- encoding: utf-8 -*-
# stub: activeresource 6.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "activeresource".freeze
  s.version = "6.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rails/activeresource/issues", "changelog_uri" => "https://github.com/rails/activeresource/releases/tag/v6.1.4", "documentation_uri" => "http://rubydoc.info/gems/activeresource", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rails/activeresource/tree/v6.1.4" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Heinemeier Hansson".freeze]
  s.date = "2024-10-31"
  s.description = "REST on Rails. Wrap your RESTful web app with Ruby classes and work with them like Active Record models.".freeze
  s.email = "david@loudthinking.com".freeze
  s.homepage = "http://www.rubyonrails.org".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "REST modeling framework (part of Rails).".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 6.0"])
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 6.0"])
    s.add_runtime_dependency(%q<activemodel-serializers-xml>.freeze, ["~> 1.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<mocha>.freeze, [">= 0.13.0"])
    s.add_development_dependency(%q<rexml>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 6.0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 6.0"])
    s.add_dependency(%q<activemodel-serializers-xml>.freeze, ["~> 1.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0.13.0"])
    s.add_dependency(%q<rexml>.freeze, [">= 0"])
  end
end
