# NotchNook Pro

Install:

```bash
brew install --cask getnotchnook/v2/notchnook-v2
```

Update:

```bash
brew upgrade --cask getnotchnook/v2/notchnook-v2
```

Release metadata is synchronized from the official signed Pro appcast. The release publisher dispatches `pro-release-published` after publication; the workflow verifies the feed signature and installer checksum before committing the cask version and hash. Manual dispatch runs the same validation. No app source, licensing service or credentials are stored here.
