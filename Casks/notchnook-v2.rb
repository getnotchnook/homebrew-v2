cask "notchnook-v2" do
  version "2.0,2017"
  sha256 "6f227e6ff4e2fc6aadbe218a7fd188a0065c96153c9f5a502c379109fcdeefb8"

  url "https://notchnook-v2-licensing.lo-cafe-public.workers.dev/updates/v2/NotchNook-v2-#{version.csv.first}-build#{version.csv.second}.dmg"
  name "NotchNook Pro"
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
