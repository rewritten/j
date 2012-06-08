# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.authors       = ["Saverio Trioni"]
  gem.email         = ["saverio.trioni@gmail.com"]
  gem.description   = %q{J interpreter, and exercise}
  gem.summary       = %q{Implements the J language inside the Ruby VM}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "j"
  gem.require_paths = ["lib"]
  gem.version       = "0"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_dependency "state_machine"
end
