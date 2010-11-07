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

      add(dir, Pathname(`git config --get core.excludesfile`.strip))

      dir.find do |path|
        Find.prune if ignore?(path)
        if path.directory? && (ignore_file = path + '.gitignore').file?
          add(path, ignore_file)
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
      "^#{Regexp.escape(dir)}/(?:#{file_pattern.join('|')})$"
    end
    def folder_r
      "^#{Regexp.escape(dir)}/(?:#{folder_pattern.join('|')})$"
    end

  private

    def add(parent, ignore_file)
      current_file_pattern = []
      current_folder_pattern = []
      ignore_file.readlines.map do |line|
        line.lstrip[/(.*?)(\r?\n)?$/, 1] # this strange stuff strips line, but allows mac Icon\r files to be ignored
      end.reject do |line|
        line.empty? || %w[# !].include?(line[0, 1])
      end.each do |line|
        pattern = Regexp.escape(line).gsub(/\\\*+/, '[^/]*') # understand only * pattern
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
        parent_pattern = Regexp.escape(parent.relative_path_from(dir))
        current_file_pattern = "#{parent_pattern}/(?:#{current_file_pattern})"
        current_folder_pattern = "#{parent_pattern}/(?:#{current_folder_pattern})"
      end
      file_pattern << current_file_pattern
      folder_pattern << current_folder_pattern
    end
  end
end
