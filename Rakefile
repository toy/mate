begin
  require 'jeweler'

  name = 'mate'

  Jeweler::Tasks.new do |gem|
    gem.name = name
    gem.summary = %Q{TextMate project builder using git ignores for exclusions}
    gem.homepage = "http://github.com/toy/#{name}"
    gem.authors = ['Boba Fat']
    gem.add_dependency 'plist'
  end

  Jeweler::GemcutterTasks.new

  require 'pathname'
  desc "Replace system gem with symlink to this folder"
  task 'ghost' do
    gem_path = Pathname(Gem.searcher.find(name).full_gem_path)
    current_path = Pathname('.').expand_path
    system('rm', '-r', gem_path)
    system('ln', '-s', current_path, gem_path)
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
