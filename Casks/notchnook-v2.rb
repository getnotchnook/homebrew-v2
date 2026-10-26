cask "notchnook-v2" do
  version "2.0,2021"
  sha256 "4ef1bb077659f0747749a27394baf8f160651c885a8b5c2afd57376d2856b32c"

  on_sonoma do
    if MacOS.full_version < MacOSVersion.new("14.6")
      disable! date:    "2026-10-23",
               because: "requires macOS 14.6 or later"
    end
  end

  url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/NotchNook-v2-#{version.csv.first}-build#{version.csv.second}.dmg"
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

  app "NotchNook 2.0.app"

  uninstall quit: "com.getnotchnook.NotchNookPro"
end
