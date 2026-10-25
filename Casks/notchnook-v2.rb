cask "notchnook-v2" do
  version "2.0,2011"
  sha256 "97e61c73ab3aea3cba6121f89bda57ec41313c37b5713fbfc6d2e76404bb74db"

  url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/NotchNook-v2-#{version.csv.first}-build#{version.csv.second}.dmg"
  name "NotchNook 2.0"
  desc "Notch workspace for Mac"
  homepage "https://getnotchnook.com/"

  livecheck do
    url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "NotchNook 2.0.app"

  on_sonoma do
    disable! date: "2026-10-23", because: "requires macOS 14.6 or later" if MacOS.version < MacOSVersion.new("14.6")
  end

  uninstall quit: "com.getnotchnook.NotchNookPro"
end
