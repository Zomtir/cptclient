#! /bin/bash

ARCH="$1"

if [[ -z "$ARCH" ]]; then
  echo "ARCH as first parameter is required" >&2
  exit 1
fi

DART_DEFINES=(
    --dart-define=SERVER_SCHEME=$SERVER_SCHEME
    --dart-define=SERVER_HOST=$SERVER_HOST
    --dart-define=SERVER_PORT=$SERVER_PORT
)

mkdir -p release/

# WEB
if [[ "$ARCH" == "web" ]]; then
    flutter build web "${DART_DEFINES[@]}" --wasm
    tar -czf release/cptclient-web.tar.gz -C build/web .
fi

# LINUX
if [[ "$ARCH" == "linux" ]]; then
    flutter build linux "${DART_DEFINES[@]}"
    tar -czf release/cptclient-linux-amd64.tar.gz -C build/linux/x64/release/bundle .
fi

# ANDROID
if [[ "$ARCH" == "apk" ]]; then
    flutter build apk "${DART_DEFINES[@]}"
    cp build/app/outputs/flutter-apk/app-release.apk release/cptclient-android.apk
fi

# WINDOWS
if [[ "$ARCH" == "windows" ]]; then
    flutter build windows "${DART_DEFINES[@]}"
    zip -r release/cptclient-windows-amd64.zip build/windows/x64/runner/Release/* -j
fi

# MACOS
if [[ "$ARCH" == "macos" ]]; then
    flutter build macos "${DART_DEFINES[@]}"
    tar -czf release/cptclient-macos-arm64.tar.gz -C "build/macos/Build/Products/Release/Course Participation Tracker.app" .
fi

# IOS
if [[ "$ARCH" == "ios" ]]; then
    flutter build ios "${DART_DEFINES[@]}"
fi

exit 0

