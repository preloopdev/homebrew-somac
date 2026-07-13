class Somac < Formula
  desc "Fast ephemeral macOS VMs for local CI on Apple Silicon"
  homepage "https://github.com/preloopdev/somac"
  url "https://github.com/preloopdev/somac/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b5feab327a386d38035de3565ca5f7193dca1c6114125683fa43ee2c01b79b58"
  license "MIT"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    system "swift", "build", "-c", "release", "--disable-automatic-resolution", "--disable-sandbox",
      "-Xswiftc", "-strict-concurrency=minimal"

    bin.install ".build/release/somac"
    bin.install ".build/release/somac-agent"

    system "codesign", "--force", "--sign", "-",
      "--entitlements", buildpath / "somac.entitlements", bin / "somac"
    system "codesign", "--force", "--sign", "-", bin / "somac-agent"
  end

  test do
    assert_match "0.1.0", shell_output("#{bin}/somac --version")
  end
end
