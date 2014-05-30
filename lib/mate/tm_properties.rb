require 'pathname'

module Mate
  class TmProperties
    attr_reader :dir, :file
    def initialize(dir)
      @dir = Pathname(dir).expand_path
      @file = @dir + '.tm_properties'
    end

    def save
      ignores = Ignores.new(dir)

      lines = if file.exist?
        file.readlines.reject do |line|
          line =~ Ignores::GENERATED_R
        end
      else
        []
      end

      @file.open('w') do |f|
        f.puts ignores.lines
        f.puts lines
      end
    end
  end
end

require 'mate/tm_properties/ignores'
