# Store screenshot artwork

`TapRecoUITests/testCaptureStoreScreenshots` captures the production views in DEBUG-only screenshot scenes. The screenshot fixtures do not load or save the user's recordings and do not start ads or request startup permissions. They are disabled in Release builds.

Capture for the desired simulator destinations using `xcodebuild test -only-testing:TapRecoUITests/TapRecoUITests/testCaptureStoreScreenshots -resultBundlePath <result.xcresult>`, then:

```sh
xcrun xcresulttool export attachments --path <result.xcresult> --output-path <attachments>
python3 Tools/StoreScreenshots/extract_captures.py <attachments> output/store-screenshots
swiftc -module-cache-path /tmp/tapreco-swift-cache Tools/StoreScreenshots/render.swift -o /tmp/tapreco-render-store
/tmp/tapreco-render-store
python3 Tools/StoreScreenshots/check_and_gallery.py
```

The scripts run from the repository root. `render.swift` uses AppKit/Core Graphics, system fonts, unmodified simulator captures and the extracted character asset. It creates new code-native promotional layouts and does not replace the original reference PNGs. See the output README for the distinction between real captures and the localized share-panel reconstruction.

`copy.json` and `share-copy.json` provide the exact text. `illustration-prompt.txt` records the built-in ImageGen extraction request. Every final PNG is opaque RGB and follows its device capture's pixel dimensions.
