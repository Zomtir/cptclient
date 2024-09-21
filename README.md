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
flutter build web
```

### Initial admin user

As long as there is a temporary super-user ('admin' by default) configured in the server configuration file (cptserver.toml), you can login as this user
with any password (the mask require >=1 password length) with full permissions.

After login, you should perform those steps:
- Change your first name and last name placeholders in the user administration.
- Change your password in the user administration. This will also generate new salt/pepper hashes.
- Create a new team in the team administration (e.g. "Admin" team).
- Give the admin team all permissions.
- Add yourself to the admin team.
- Remove the super-user from the server configuration file.
- Restart the server.

### Localization

Current supported locales are EN and DE in `main.dart`.

```
supportedLocales: [
  Locale('en'), // English
  Locale('de'), // German
],
```

The localization files are located at `lib/l10n/` and can be applied to the package with `flutter gen-l10n`.

### App Name

Change App name with: `flutter pub global activate rename` & `rename setAppName --targets ios,android,macos,windows,web --value "YourAppName"`
You can also set the name for linux, but this isn't the launcher name. Update debians `.desktop` file manually.

### Icons

Generate launcher icons with: `flutter pub run flutter_launcher_icons`

## Releases

When you make a new release, this is the targeted procedure.

The versioning scheme is `MAJOR.MINOR.PATCH`, increment the:
- MAJOR version when you make substantial API changes or core reworks
- MINOR version when you make any API changes
- PATCH version when you make backward compatible changes

Collect the changes since the previous release and add them to the [CHANGELOG](CHANGELOG.md).
```
git log --format=%B v0.9..HEAD
```

Tag the commit with a release tag and a 'v' prefix.
```
git tag v1.0.0
git push --follow-tags
```
Adapt the [Pubspec file](pubspec.yaml). Increment the build number (`+1`) behind the version name by one integer.
```
version: 1.0.0+1
```

## License

The code is dedicated to the Public Domain as declared in the [License](LICENSE.md).

## Contributing

Contributing to the project implies a copyright release according to the [Waiver](WAIVER.md) unless 
stated otherwise.

You are very welcome to explicitly state your approval with a simple statement such as
`Dedicated to Public Domain` in your patches. You can also sign the [Waiver](WAIVER.md) with GPG
while listing yourself as [Author](AUTHORS.md).

```bash
# Generate a GPG key
gpg --full-generate-key
# Optionally export your public key and add it to your Github account and/or a keyserver.
gpg --list-keys
gpg --armor --export <KEYID>
# Sign the waiver
gpg --detach-sig --armor WAIVER.md
# View the signature
cat WAIVER.md.asc
# Verify the signature
gpg --verify WAIVER.md.asc WAIVER.md
```
