class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.0.9/glyphlow.tar.gz"
  sha256 "4f57bdb8ac5ccf9e1483c851de22fb929203e691413c15be8d43ae7ad6ad11ac"
  version "0.0.9"
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
