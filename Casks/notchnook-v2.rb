cask "notchnook-v2" do
  version "2.0,2001"
  sha256 "ad966af882c82b05bfdd3fb93a70d480489f36592c2acd13313da6e047b3f4ee"

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
