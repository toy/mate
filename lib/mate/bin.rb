require 'shellwords'

module Mate
  module Bin
    class << self
      def v2
        mate_version(/^mate 2.\d+/) or abort 'Can\'t find mate binary v2'
      end

    private

      def mate_version(regexp)
        IO.popen('which -a mate', &:readlines).map(&:strip).find{ |bin| `#{bin.shellescape} -v` =~ regexp }
      end
    end
  end
end
