module Mate
  class Tmproj::Ignores
    BINARY_EXTENSIONS = [
      %w[jpe?g png gif psd], # images
      %w[zip tar t?(?:g|b)z], # archives
      %w[mp3 mov], # media
      %w[log tmp swf fla pdf], # other
    ]
    DOUBLE_ASTERISK_R = '(?:.+/)?'

    attr_reader :dir, :file_pattern, :folder_pattern
    def initialize(dir)
      @dir = dir
      @file_pattern = ["#{DOUBLE_ASTERISK_R}.+\\.(?:#{BINARY_EXTENSIONS.flatten.join('|')})"]
      @folder_pattern = ["#{DOUBLE_ASTERISK_R}.git"]

      process(dir, Pathname(`git config --get core.excludesfile`.strip).expand_path)
      process(dir, Pathname('~/.tmignore').expand_path)

      dir.find do |path|
        Find.prune if ignore?(path)
        if path.directory?
          %w[.gitignore .tmignore .git/info/exclude].each do |ignore_file_name|
            if (ignore_file = path + ignore_file_name).file?
              process(path, ignore_file)
            end
          end
        end
      end
    end

    def ignore?(path)
      case
      when path.file?
        path.to_s =~ /#{file_r}/
      when path.directory?
        path.to_s =~ /#{folder_r}/
      end
    end

    def file_r
      "^#{Regexp.escape(dir.to_s)}/(?:#{file_pattern.join('|')})$"
    end
    def folder_r
      "^#{Regexp.escape(dir.to_s)}/(?:#{folder_pattern.join('|')})$"
    end

  private

    def process(parent, ignore_file)
      return unless ignore_file.exist?
      current_file_pattern = []
      current_folder_pattern = []
      ignore_file.readlines.map do |line|
        line.lstrip[/(.*?)(\r?\n)?$/, 1] # this strange stuff strips line, but allows mac Icon\r files to be ignored
      end.reject do |line|
        line.empty? || %w[# !].include?(line[0, 1])
      end.each do |line|
        pattern = glob2regexp(line)
        pattern = "#{DOUBLE_ASTERISK_R}#{pattern}" unless line['/']
        pattern.sub!(/^\//, '')
        unless pattern.sub!(/\/$/, '')
          current_file_pattern << pattern
        end
        current_folder_pattern << pattern
      end
      current_file_pattern = current_file_pattern.join('|')
      current_folder_pattern = current_folder_pattern.join('|')
      unless parent == dir
        parent_pattern = Regexp.escape(parent.relative_path_from(dir).to_s)
        current_file_pattern = "#{parent_pattern}/(?:#{current_file_pattern})"
        current_folder_pattern = "#{parent_pattern}/(?:#{current_folder_pattern})"
      end
      file_pattern << current_file_pattern
      folder_pattern << current_folder_pattern
    end

    def glob2regexp(glob)
      glob.gsub(/\[([^\]]*)\]|\{([^\}]*)\}|(\*+)|(\?+)|./) do |m|
        case
        when $1
          "[#{Regexp.escape($1)}]"
        when $2
          "(?:#{Regexp.escape($2).split(',').join('|')})"
        when $3 == '*'
          '[^/]*'
        when $3
          '.*'
        when $4 == '?'
          '[^/]'
        when $4
          "[^/]{#{$4.length}}"
        else
          Regexp.escape(m)
        end
      end
    end
  end
end
