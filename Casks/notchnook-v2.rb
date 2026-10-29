cask "notchnook-v2" do
  version "2.0.2,2062"
  sha256 "a73ba1cc0146588d5dbedf7573b1c1d569b7f6d2b33c3bb7912a85da20d30e9a"

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
