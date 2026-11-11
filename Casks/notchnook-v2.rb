cask "notchnook-v2" do
  version "2.0.9,2075"
  sha256 "2cb7e3c7245dfd667ed1c2c3fafa0549a294f1897f335834fe4b5348b9ad2f09"

  on_sonoma do
    if MacOS.full_version < MacOSVersion.new("14.6")
      disable! date:    "2026-10-23",
               because: "requires macOS 14.6 or later"
    end
  end

  url "https://getnotchnook.com/pro-updates/v2/NotchNook-Pro-build#{version.csv.second}.dmg"
  name "NotchNook Pro"
  desc "Notch workspace"
  homepage "https://getnotchnook.com/"

  livecheck do
    url "https://getnotchnook.com/pro-updates/v2/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "NotchNook Pro.app"

  uninstall quit: "com.getnotchnook.NotchNookPro"
end
