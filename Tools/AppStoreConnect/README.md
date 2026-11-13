# App Store Connect registration

These scripts use Python's standard library and OpenSSL to call Apple's API. Private keys stay at the supplied path; JWTs and signed upload URLs are kept in memory and are not written to reports.

`read_store.py --key <p8-path> --issuer <issuer-id>` reads the app, current version metadata, and the asset-library reference data. `preflight.py` backs up current placements. Both are read-only.

The exact upload payload is `appstore/metadata-1.4.1.json`. Japanese text is preserved. New locales are `en-US`, `ko`, `zh-Hant`, `es-ES`, `es-MX`, `pt-BR`, and `id`; the two Spanish localizations share the same five images per device. Support, marketing, and privacy policy URLs are copied from Japanese.

```sh
python3 Tools/AppStoreConnect/upload.py --key <p8-path> --issuer <issuer-id>
python3 Tools/AppStoreConnect/upload.py --key <p8-path> --issuer <issuer-id> --apply
python3 Tools/AppStoreConnect/upload.py --key <p8-path> --issuer <issuer-id> --verify-only
```

Without `--apply`, validation is read-only. Applying requires version 1.4.1 and its app-info record to remain in `PREPARE_FOR_SUBMISSION`. The script validates all 70 opaque PNGs against Apple's live reference specifications, creates or updates localized metadata, uploads images to the asset library, waits for processing, then places and orders five screenshots per target display group. The Spanish locales reuse assets rather than uploading duplicates.

Only older screenshot placements in the same two target display groups are replaced. Their source assets remain in the library, with prior placement data recorded in the checkpoint. Existing previews and other display groups are retained. The script never uploads a build, submits for review, changes sale countries, or publishes a version.

`appstore/upload-state-1.4.1.json` is a resumable checkpoint. `appstore/upload-report-1.4.1.json` is created only after re-reading and verifying metadata, shared URLs, image counts, placement order, placement state, unchanged Japanese base text and expected release notes, unchanged live app-info localizations, and the version's draft state.

References:
- https://developer.apple.com/documentation/appstoreconnectapi/app-asset-library
- https://developer.apple.com/documentation/appstoreconnectapi/uploading-assets-to-app-store-connect
- https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications
- https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information

`update_release_notes.py --key <p8-path> --issuer <issuer-id>` updates only the localized What’s New fields for 1.4.1, verifies every other version-localization field remains unchanged, and persists the expected release notes in the metadata payload.
