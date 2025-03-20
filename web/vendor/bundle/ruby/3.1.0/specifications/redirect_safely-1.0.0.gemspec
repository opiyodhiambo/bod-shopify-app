# -*- encoding: utf-8 -*-
# stub: redirect_safely 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "redirect_safely".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "changelog_uri" => "https://github.com/shopify/redirect_safely/blob/master/CHANGELOG.md", "source_code_uri" => "https://github.com/shopify/redirect_safely" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shopify".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-04-29"
  s.description = "Sanitize redirect_to URLs".freeze
  s.email = ["gems@shopify.com".freeze]
  s.homepage = "https://github.com/shopify/redirect_safely".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "Sanitize redirect_to URLs".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activemodel>.freeze, [">= 0"])
    s.add_development_dependency(%q<activesupport>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    s.add_development_dependency(%q<bundler>.freeze, ["~> 1.14"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
  else
    s.add_dependency(%q<activemodel>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, ["~> 3.0"])
    s.add_dependency(%q<test-unit>.freeze, ["~> 3.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.14"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
