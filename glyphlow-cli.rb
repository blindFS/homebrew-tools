class GlyphlowCli < Formula
  desc "Command-line client for the Glyphlow server"
  homepage "https://github.com/blindFS/Glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.4/glyphlow-cli.tar.gz"
  sha256 "bef140a1a96994029153dca8c00b1750b9a5a764fb9db2dc68d7bb40e8a29e8a"
  version "0.5.4"
  revision 1
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
