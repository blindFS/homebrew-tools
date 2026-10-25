class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.3/glyphlow.tar.gz"
  sha256 "2689e3b094730b74cd2834d4ddf1a56da0bce176294148ad80e0c77e1e95b724"
  version "0.5.3"
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
