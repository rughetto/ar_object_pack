# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ar_object_pack}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Rue The Ghetto"]
  s.date = %q{2009-01-05}
  s.description = %q{ActiveRecord plugin originally designed for Merb use that allows the packaging of objects into formats: marshal, json and yaml.}
  s.email = %q{ru_ghetto@rubyghetto.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/ar_object_pack", "lib/ar_object_pack/object_packer.rb", "lib/ar_object_pack.rb", "spec/ar_object_pack_spec.rb", "spec/database_spec_setup.rb", "spec/irb_tester.rb", "spec/spec.opts", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/rughetto/ar_object_pack}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{ActiveRecord plugin originally designed for Merb use that allows the packaging of objects into formats: marshal, json and yaml.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
  end
end
