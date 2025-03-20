# -*- encoding: utf-8 -*-
# stub: shopify_api 14.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "shopify_api".freeze
  s.version = "14.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shopify".freeze]
  s.date = "2025-01-06"
  s.description = "This gem allows Ruby developers to programmatically access the admin\nsection of Shopify stores.\n".freeze
  s.email = "developers@shopify.com".freeze
  s.extra_rdoc_files = ["LICENSE".freeze, "README.md".freeze]
  s.files = ["LICENSE".freeze, "README.md".freeze]
  s.homepage = "https://shopify.dev/docs/apps".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "The gem for accessing the Shopify API".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<hash_diff>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<httparty>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<jwt>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<oj>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<openssl>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<securerandom>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<sorbet-runtime>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<zeitwerk>.freeze, ["~> 2.5"])
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    s.add_dependency(%q<hash_diff>.freeze, [">= 0"])
    s.add_dependency(%q<httparty>.freeze, [">= 0"])
    s.add_dependency(%q<jwt>.freeze, [">= 0"])
    s.add_dependency(%q<oj>.freeze, [">= 0"])
    s.add_dependency(%q<openssl>.freeze, [">= 0"])
    s.add_dependency(%q<securerandom>.freeze, [">= 0"])
    s.add_dependency(%q<sorbet-runtime>.freeze, [">= 0"])
    s.add_dependency(%q<zeitwerk>.freeze, ["~> 2.5"])
  end
end
