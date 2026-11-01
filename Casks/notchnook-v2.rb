cask "notchnook-v2" do
  version "2.0.4,2067"
  sha256 "2fcb418233a9cd0c6bc33c862bd475b037946aca9499a220f1cdf0e3e4048a1b"

  on_sonoma do
    if MacOS.full_version < MacOSVersion.new("14.6")
      disable! date:    "2026-10-23",
               because: "requires macOS 14.6 or later"
    end
  end

  url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/NotchNook-Pro-build#{version.csv.second}.dmg"
  name "NotchNook Pro"
  desc "Notch workspace"
  homepage "https://getnotchnook.com/"

  livecheck do
    url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "NotchNook Pro.app"

  uninstall quit: "com.getnotchnook.NotchNookPro"
end
