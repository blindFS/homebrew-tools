class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindfs/glyphlow/archive/v0.0.6.tar.gz"
  sha256 "be12f671dbfb4ebea4a1652a12820f20d5943af7d29f2164719ee740d4c21edf"
  license "MIT"

  def install
    bin.install "glyphlow"
  end

  service do
    run [opt_bin/"glyphlow"]
    run_type :immediate
    keep_alive true
    log_path var/"log/glyphlow.log"
    error_log_path var/"log/glyphlow.log"
  end
end
