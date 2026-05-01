class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.0.7/glyphlow.tar.gz?v1"
  sha256 "2e11cc715d5a1fefea2e8c0764f0a9de8719490c39a3091b34119440f2e83fad"
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
