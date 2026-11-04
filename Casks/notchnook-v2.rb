cask "notchnook-v2" do
  version "2.0.7,2073"
  sha256 "c7c8cd4badc8a6daec2397a378045633bdf0062b04d0e2bbbac1fa1a4544dba9"

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
