require 'pathname'
require 'mate/git'

module Mate
  class TmProperties
    def self.create(dir)
      new(Git.toplevel(dir) || dir).save
    end

    def initialize(dir)
      @dir = Pathname(dir).expand_path
      @file = @dir + '.tm_properties'
      @lines = @file.exist? ? @file.read.split("\n") : []
      @other_lines = @lines.reject{ |line| line =~ Ignores::GENERATED_R }
    end

    def save
      ignores = Ignores.new(@dir)

      write(ignores.lines + @other_lines)
    end

    def cleanup
      if @other_lines.empty?
        @file.unlink if @file.exist?
      else
        write(@other_lines)
      end
    end

  private

    def write(lines)
      return if lines == @lines

      @file.open('w') do |f|
        f.puts lines
      end
    end
  end
end

require 'mate/tm_properties/ignores'
