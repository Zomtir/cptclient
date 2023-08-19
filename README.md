## Info

This is the client application for connecting to cptserver. CPT stands for Course Participation Tracker.

## Getting Started

Should work out of the box, if the cptserver is running. The server details have to be adapted in `cptclient.yaml`.

```
flutter gen-l10n
flutter build web
```

## TODO
- Make calendar functional
- Mailing/chat/notification support
- Slot reservation time limitations
  - Add opening dates / hours (e.g 9:00 to 22:00)
  - Add closing dates / hours (holidays)

## Wishlist
- Compatibility for NFC login