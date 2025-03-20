# -*- encoding: utf-8 -*-
# stub: shopify_app 22.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "shopify_app".freeze
  s.version = "22.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shopify".freeze]
  s.date = "2025-03-17"
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.3.15".freeze
  s.summary = "This gem is used to get quickly started with the Shopify API".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<activeresource>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.7"])
    s.add_runtime_dependency(%q<rails>.freeze, ["> 5.2.1"])
    s.add_runtime_dependency(%q<redirect_safely>.freeze, ["~> 1.0"])
    s.add_runtime_dependency(%q<shopify_api>.freeze, [">= 14.7.0", "< 15.0"])
    s.add_runtime_dependency(%q<sprockets-rails>.freeze, [">= 2.0.0"])
    s.add_runtime_dependency(%q<jwt>.freeze, [">= 2.2.3"])
    s.add_development_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry-stack_explorer>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rb-readline>.freeze, [">= 0"])
    s.add_development_dependency(%q<ruby-lsp>.freeze, [">= 0"])
    s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
    s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
  else
    s.add_dependency(%q<activeresource>.freeze, [">= 0"])
    s.add_dependency(%q<addressable>.freeze, ["~> 2.7"])
    s.add_dependency(%q<rails>.freeze, ["> 5.2.1"])
    s.add_dependency(%q<redirect_safely>.freeze, ["~> 1.0"])
    s.add_dependency(%q<shopify_api>.freeze, [">= 14.7.0", "< 15.0"])
    s.add_dependency(%q<sprockets-rails>.freeze, [">= 2.0.0"])
    s.add_dependency(%q<jwt>.freeze, [">= 2.2.3"])
    s.add_dependency(%q<byebug>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<pry-nav>.freeze, [">= 0"])
    s.add_dependency(%q<pry-stack_explorer>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rb-readline>.freeze, [">= 0"])
    s.add_dependency(%q<ruby-lsp>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.4"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
  end
end
