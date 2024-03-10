## Info

This is the client application for connecting to cptserver. CPT stands for Course Participation Tracker.

## Getting Started

Should mostly work out of the box, if a cptserver is running.

1) Install Android SDK
   1) Enable Dart Plugin
   2) Enable Flutter Plugin
2) Install Flutter SDK
3) Adapt the server details in `cptclient.yaml`. A template can be found in `cptclient-template.yaml`.
4) Choose Chrome (web) as build target and press the Run button. Alternatively you can use the command line:

```
flutter gen-l10n
flutter build web
```

## Releases

When you make a new release, this is the targeted procedure.

The versioning scheme is `MAJOR.MINOR.PATCH`, increment the:
- MAJOR version when you make substantial API changes or core reworks
- MINOR version when you make any API changes
- PATCH version when you make backward compatible changes

As long as the `MAJOR` release is `0.x`, it is considered a pre-release. The API and feature set \
might be incomplete and unstable.

```
# Tag the commit with a release tag and a 'v' prefix.
# The `PATCH` version is omitted for the `.0` increment.
git tag v0.7

# Adapt the Pubspec file
# Increment the version code by one integer. Keep the value at 1 for prerelease versions.
pubspec.yaml
> version: 0.7.0+1

# The local properties will most likely be adapted by your AndroidStudio IDE:
android/local.properties
> flutter.versionCode=1
> flutter.versionName=0.7.0

# Adapt the Android App properties
android/app/src/main/AndroidManifest.xml
> android:versionCode="1"
> android:versionName="0.7"
```

## License

The code is dedicated to the [Public Domain](LICENSE.md).

## Contributing

Contributing to the project implies a copyright release as stated in the [Waiver](WAIVER.md) unless 
stated otherwise.

You are very welcome to explicitly state your approval with a simple statement such as
`Dedicated to Public Domain` in your patches. You can also sign the [Waiver](WAIVER.md) with GPG
while listing yourself as [Author](AUTHORS.md).

```bash
# Generate a GPG key
gpg --full-generate-key
# Sign the waiver
gpg --no-version --armor --sign WAIVER.md
# Copy the signature
cat WAIVER.md.asc
# Optionally export your public key and add it to your Github account and/or a keyserver.
gpg --list-keys
gpg --armor --export <KEYID>
```