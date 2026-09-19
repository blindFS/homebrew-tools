class GlyphlowCli < Formula
  desc "Command-line client for the Glyphlow server"
  homepage "https://github.com/blindFS/Glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.4.0/glyphlow-cli.tar.gz"
  sha256 "6f83f7fae01572623db50947cb505f4cdafbd8a6ff2224b9dfd4d0397c780c70"
  version "0.4.0"
  license "MIT"

  def install
    bin.install "glyphlow-cli"
    generate_completions_from_executable(bin/"glyphlow-cli", "complete")
  end

  test do
    assert_match "Command line client", shell_output("#{bin}/glyphlow-cli --help")
  end
end
