# -*- encoding: utf-8 -*-
# stub: hash_diff 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "hash_diff".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Coding Zeal".freeze, "Adam Cuppy".freeze, "Mike Bianco".freeze]
  s.date = "2022-08-29"
  s.description = "Diff tool for deep Ruby hash comparison".freeze
  s.email = ["info@codingzeal.com".freeze, "mike@mikebian.co".freeze]
  s.homepage = "https://github.com/CodingZeal/hash_diff".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.15".freeze
  s.summary = "Deep Ruby Hash comparison".freeze

  s.installed_by_version = "3.3.15" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1"])
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
  end
end
