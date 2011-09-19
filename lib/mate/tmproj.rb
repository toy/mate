require 'pathname'
require 'digest/sha2'
require 'plist'

module Mate
  class Tmproj
    TMPROJ_DIR = Pathname('~').expand_path + '.tmprojs'

    attr_reader :dirs, :file
    def initialize(dirs)
      @dirs = dirs.map{ |dir| Pathname(dir).expand_path }
      @file = TMPROJ_DIR + [
        Digest::SHA256.hexdigest(@dirs.join('-').downcase),
        "#{common_dir(@dirs).basename}.tmproj"
      ].join('/')
    end

    def open
      data = Plist::parse_xml(file) rescue {}

      data['documents'] = dirs.map do |dir|
        ignores = Ignores.new(dir)
        {
          :expanded => true,
          :name => dir.basename.to_s,
          :regexFileFilter => "!#{ignores.file_r}",
          :regexFolderFilter => "!#{ignores.folder_r}",
          :sourceDirectory => dir.to_s
        }
      end
      data['fileHierarchyDrawerWidth'] ||= 269
      data['metaData'] ||= {}
      data['showFileHierarchyDrawer'] = true unless data.has_key?('showFileHierarchyDrawer')
      dimensions = IO.popen(%q{osascript -e 'tell application "Finder" to get bounds of window of desktop'}, &:read).scan(/\d+/).map(&:to_i)
      data['windowFrame'] ||= "{{#{dimensions[0] + 100}, #{dimensions[1] + 50}}, {#{dimensions[2] - 200}, #{dimensions[3] - 100}}}"

      file.dirname.mkpath
      file.open('w'){ |f| f.write(data.to_plist) }

      system 'open', file.to_s
    end

  private

    def common_dir(paths)
      common = nil
      paths.each do |path|
        if path.file?
          path = path.dirname
        end
        ascendants = []
        path.ascend do |ascendant|
          ascendants << ascendant
        end
        unless common
          common = ascendants
        else
          common &= ascendants
        end
      end
      common && common.first
    end
  end
end

require 'mate/tmproj/ignores'
