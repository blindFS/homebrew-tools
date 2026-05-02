class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.0.8/glyphlow.tar.gz?v2"
  sha256 "a33f3235479f7f5c824b5a2a7487f35488d3a149160855d862bfd9a7718e14b5"
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
