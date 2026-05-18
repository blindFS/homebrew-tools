class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.0.16/glyphlow.tar.gz"
  sha256 "d9cdb2c400533386aea1ff97ebe884a78c1f17a0291a96b5f28b5c7f69a96b3c"
  version "0.0.16"
  revision 1
  license "MIT"

  def install
    bin.install "glyphlow"
  end

  service do
    run [opt_bin/"glyphlow"]
    run_type :immediate
    keep_alive true
    environment_variables PATH: "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin"
    log_path var/"log/glyphlow.log"
    error_log_path var/"log/glyphlow.log"
  end
end
