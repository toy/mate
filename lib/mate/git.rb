module Mate
  module Git
    class << self
      def excludesfile(workind_dir)
        expand_path IO.popen(%W[git -C #{workind_dir} config --get core.excludesfile], &:read)
      end

      def global_tmignore
        expand_path '~/.tmignore'
      end

      def toplevel(workind_dir)
        expand_path IO.popen(%W[git -C #{workind_dir} rev-parse --show-toplevel], err: '/dev/null', &:read)
      end

    private

      def expand_path(path)
        return unless path

        path = path.strip
        return if path == ''

        Pathname(path).expand_path
      end
    end
  end
end
