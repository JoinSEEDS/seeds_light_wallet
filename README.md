# seeds_light_wallet

[![Actions Status](https://github.com/7flash/flutter_seeds_wallet/workflows/Guard/badge.svg)](https://github.com/7flash/flutter_seeds_wallet/actions)

[![Codemagic build status](https://api.codemagic.io/apps/5e42439035303b6098ae7da4/5e42439035303b6098ae7da3/status_badge.svg)](https://codemagic.io/apps/5e42439035303b6098ae7da4/5e42439035303b6098ae7da3/latest_build)

Opensource Wallet & Explorer by joinseeds.com

A payment platform and financial ecosystem to empower humanity and heal our planet

## Getting Started

```
git clone https://github.com/7flash/flutter_seeds_wallet.git
cd flutter_seeds_wallet
flutter pub get
flutter run --no-sound-null-safety lib/main.dart
```

### Sound null safety is off
Run with ```--no-sound-null-safety``` flags as there are some external libraries that are not null safe

## Dev configuration

Use the projects git hooks
```
git config core.hooksPath .githooks/
```

## Build

### Build for Android

Create an app bundle and upload to Google Play

```flutter build appbundle --no-sound-null-safety lib/main.dart```

### Build for iOS 

For iOS App store release, we build with XCode - but before running the XCode build, we need to run the flutter build for iOS.

1 - Build for iOS flutter
```flutter build ios --no-sound-null-safety lib/main.dart```

2 - Build with XCode for App store distrubution as usual

