# seeds_light_wallet

Opensource Wallet & Explorer by joinseeds.com

A payment platform and financial ecosystem to empower humanity and heal our planet

## Getting Started

```
git clone git@github.com:JoinSEEDS/seeds_light_wallet.git
cd seeds_light_wallet
flutter pub get
flutter run
```
## Code Rules
Set line length to 120 in your editor
Most other rules are definied in the flutter linter file.

## Build

### Build for Android

Create an app bundle and upload to Google Play

```flutter build appbundle```

### Build for iOS 

For iOS App store release, we build with XCode - but before running the XCode build, we need to run the flutter build for iOS.

1 - Build for iOS flutter
```flutter build ios```

2 - Build with XCode for App store distrubution as usual

