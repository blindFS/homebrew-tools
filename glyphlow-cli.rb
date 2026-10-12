class GlyphlowCli < Formula
  desc "Command-line client for the Glyphlow server"
  homepage "https://github.com/blindFS/Glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.0/glyphlow-cli.tar.gz"
  sha256 "7f74e0b6c59ca0882391ce038a6e3d86c8b73b823bfb4108bd000b0abaf30b6c"
  version "0.5.0"
  license "MIT"

  def install
    bin.install "glyphlow-cli"
    # `glyphlow-cli complete bash|zsh|fish` prints the script to stdout; this
    # installs them into the usual bash/zsh/fish completion directories.
    generate_completions_from_executable(bin/"glyphlow-cli", "complete", shells: [:bash, :zsh, :fish])
  end

  test do
    assert_match "Command line client", shell_output("#{bin}/glyphlow-cli --help")
    assert_match "#compdef glyphlow-cli", shell_output("#{bin}/glyphlow-cli complete zsh")
    assert_match "complete -c glyphlow-cli", shell_output("#{bin}/glyphlow-cli complete fish")
  end
end
