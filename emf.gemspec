# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'emf/version'

Gem::Specification.new do |gem|
  gem.name                 = "emf"
  gem.version              = Emf::VERSION
  gem.authors              = ["Deepak"]
  gem.email                = ["deepakkumarnd@gmail.com"]
  gem.homepage             = ""
  gem.summary              = %q{ A eventmachine based web application framework }
  gem.description          = %q{ A eventmachine based web application framework }
  gem.files                = `git ls-files`.split('\n')
  gem.test_files           = gem.files.grep(/^(spec|test|features)/)
  gem.executables          = gem.files.grep(/^bin/).map{ |f| File.basename(f) }
  gem.require_paths        = ["lib"]
  gem.add_development_dependency "rspec"
  gem.add_runtime_dependency "eventmachine"
end