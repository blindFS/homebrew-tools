class Glyphlow < Formula
  desc "Feature-rich manipulation of UI elements on macOS with minimal key strokes."
  homepage "https://github.com/blindfs/glyphlow"
  url "https://github.com/blindFS/Glyphlow/releases/download/v0.5.1/glyphlow.tar.gz"
  sha256 "03138894c1063fdc87ee8667f4ddea098ab2d85062865dad07f3df60c83576ff"
  version "0.5.1"
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
