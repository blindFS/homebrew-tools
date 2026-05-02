class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.0.8/glyphlow.tar.gz?v1"
  sha256 "4c66e64673d31a2aebee6b55694d355a816886818527d852eb2d9a2e2bdf0097"
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
