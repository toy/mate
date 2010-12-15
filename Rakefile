require 'rake'
require 'jeweler'
require 'rake/gem_ghost_task'

name = 'mate'

Jeweler::Tasks.new do |gem|
  gem.name = name
  gem.summary = %Q{TextMate project builder using git ignores for exclusions}
  gem.homepage = "http://github.com/toy/#{name}"
  gem.license = 'MIT'
  gem.authors = ['Ivan Kuchin']
  gem.add_runtime_dependency 'plist'
  gem.add_development_dependency 'jeweler', '~> 1.5.1'
  gem.add_development_dependency 'rake-gem-ghost'
end
Jeweler::RubygemsDotOrgTasks.new
Rake::GemGhostTask.new
