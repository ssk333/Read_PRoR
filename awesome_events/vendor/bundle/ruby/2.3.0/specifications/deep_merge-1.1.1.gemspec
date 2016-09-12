# -*- encoding: utf-8 -*-
# stub: deep_merge 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "deep_merge"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Steve Midgley"]
  s.date = "2016-08-01"
  s.description = "Recursively merge hashes."
  s.email = "dan@kallistec.com"
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "https://github.com/danielsdeleo/deep_merge"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.1"
  s.summary = "Merge Deeply Nested Hashes"

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<test-unit-minitest>, [">= 0"])
    else
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<test-unit-minitest>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<test-unit-minitest>, [">= 0"])
  end
end
