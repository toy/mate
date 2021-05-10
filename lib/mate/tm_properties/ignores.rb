require 'mate/git'

module Mate
  class TmProperties::Ignores
    GENERATED_SUFFIX = '## GENERATED ##'
    GENERATED_R = /^exclude(?:Directories)? = .* #{Regexp.escape(GENERATED_SUFFIX)}$/

    attr_reader :dir
    def initialize(dir, options)
      @dir = dir
      @exclude = ['**/.git']
      @exclude_directories = []

      process('.', Git.excludesfile(dir))
      process('.', Git.global_tmignore)
      if !options[:skip_info_exclude] && (git_dir = Git.git_dir(dir))
        process('.', git_dir + 'info/exclude')
      end

      dir.find do |path|
        next unless path.lstat.directory?

        toplevel = dir == path

        if !toplevel && (path + '.git').exist?
          TmProperties.new(path, options).save
          Find.prune
        else
          relative_path = path.relative_path_from(dir).to_s
          Find.prune if ignore_dir?(relative_path)
          %w[.gitignore .tmignore].each do |ignore_file_name|
            process(relative_path, path + ignore_file_name)
          end

          if !toplevel && (path + '.tm_properties').exist?
            TmProperties.new(path, options).cleanup
          end
        end
      end
    end

    def lines
      escaped_dir = glob_escape(dir.to_s)
      [
        "exclude = '#{escaped_dir}/#{glob_join(@exclude)}' #{GENERATED_SUFFIX}",
        "excludeDirectories = '#{escaped_dir}/#{glob_join(@exclude_directories)}' #{GENERATED_SUFFIX}",
      ].map{ |line| line.gsub("\r", '\r') }
    end

  private

    def ignore_dir?(path)
      [@exclude, @exclude_directories].any? do |patterns|
        patterns.any? do |pattern|
          File.fnmatch(pattern, path, File::FNM_PATHNAME)
        end
      end
    end

    def process(subdirectory, ignore_file)
      return unless ignore_file && ignore_file.exist?

      prefix = subdirectory == '.' ? '' : glob_escape("#{subdirectory}/")

      ignore_file.readlines.map do |line|
        line.lstrip[/(.*?)(\r?\n)?$/, 1] # this strange stuff strips line, but allows mac Icon\r files to be ignored
      end.reject do |line|
        line.empty? || line =~ /^\#/
      end.each do |pattern|
        negate = pattern.sub!(/^\!/, '')
        unless pattern.sub!(/^\//, '')
          pattern = "**/#{pattern}"
        end
        pattern = "#{prefix}#{pattern}"
        list = (pattern.sub!(/\/$/, '') ? @exclude_directories : @exclude)
        if negate
          list.delete(pattern) # negation only works for exact matches
        else
          list << pattern
        end
      end
    end

    def glob_escape(string)
      string.gsub(/([\*\?\[\]\{\}])/, '\\\\\1')
    end

    def glob_join(list)
      list.length == 1 ? list : "{#{list.join(',')}}"
    end
  end
end
