class GlyphlowCli < Formula
  desc "Command-line client for the Glyphlow server"
  homepage "https://github.com/blindFS/Glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.2/glyphlow-cli.tar.gz"
  sha256 "63686c011c4ccc29cb0358265d11f511393fd566d6df8b5c64282d33a6e62255"
  version "0.5.2"
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
