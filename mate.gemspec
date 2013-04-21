# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'mate'
  s.version     = '1.2.1'
  s.summary     = %q{TextMate project builder using git ignores for exclusions}
  s.homepage    = "http://github.com/toy/#{s.name}"
  s.authors     = ['Ivan Kuchin']
  s.license     = 'MIT'

  s.rubyforge_project = s.name

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w[lib]

  s.add_runtime_dependency 'plist'
end
