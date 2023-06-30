module Mate
  module Git
    class << self
      def excludesfile(working_dir)
        excludesfile = IO.popen(%W[git -C #{working_dir} config --get core.excludesfile], &:read)

        if excludesfile.empty?
          xdg_config_home = ENV['XDG_CONFIG_HOME']

          xdg_config_home = '~/.config' if !xdg_config_home || xdg_config_home.empty?

          excludesfile = File.join(xdg_config_home, 'git/ignore')
        end

        expand_path excludesfile
      end

      def global_tmignore
        expand_path '~/.tmignore'
      end

      def toplevel(working_dir)
        expand_path IO.popen(%W[git -C #{working_dir} rev-parse --show-toplevel], err: '/dev/null', &:read)
      end

      def git_dir(working_dir)
        expand_path IO.popen(%W[git -C #{working_dir} rev-parse --absolute-git-dir], err: '/dev/null', &:read)
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
