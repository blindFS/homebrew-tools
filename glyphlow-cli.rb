class GlyphlowCli < Formula
  desc "Command-line client for the Glyphlow server"
  homepage "https://github.com/blindFS/Glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.1/glyphlow-cli.tar.gz"
  sha256 "ea5a22848917ea6d4883d7363ee2ef621bbb9184840bb43eccfac3a4303f890f"
  version "0.5.1"
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
