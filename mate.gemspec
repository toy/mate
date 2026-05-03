# encoding: UTF-8

Gem::Specification.new do |s|
  s.name        = 'mate'
  s.version     = '3.2.0'
  s.summary     = %q{TextMate 2 properties builder using git ignores for exclusions}
  s.homepage    = "https://github.com/toy/#{s.name}"
  s.authors     = ['Ivan Kuchin']
  s.license     = 'MIT'

  s.required_ruby_version = '>= 1.9.3'

  s.metadata = {
    'bug_tracker_uri'   => "https://github.com/toy/#{s.name}/issues",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}/#{s.version}",
    'source_code_uri'   => "https://github.com/toy/#{s.name}",
  }

  s.files = Dir[*%w[
    .gitignore
    LICENSE.txt
    *.markdown
    *.gemspec
    {bin,lib}/**/*
  ]].reject(&File.method(:directory?))

  s.executables = Dir['bin/*'].map(&File.method(:basename))

  s.require_paths = %w[lib]
end
