#!/bin/sh

## archive and upload the app to ios App store

flutter build ipa --release
open -a "Transporter" "build/ios/ipa/SEEDS Wallet.ipa"

# depends on xcpretty
# If you don't have "xcpretty" installed either install it with 'gem install xcpretty' or remove
# the pipeline 

# Build the app with Flutter
# flutter build ios --release

# Archive the .app to .xcarchive
# xcodebuild archive -workspace ios/Runner.xcworkspace -scheme Runner -archivePath ios/archive/Runner.xcarchive -destination 'generic/platform=iOS' | xcpretty

# Export the .xcarchive to .ipa
# xcodebuild -exportArchive -archivePath ios/archive/Runner.xcarchive -exportOptionsPlist appstore/ExportOptions.plist -exportPath ios/build | xcpretty

# Upload to App Store using Transporter

# xcrun altool --upload-app --type ios --file "ios/build/Runner.ipa" --username "YOUR_APPLE_ID_EMAIL" --password "YOUR_APP_SPECIFIC_PASSWORD"

# Or just open the ipa file in transporter
# open -a "Transporter" /Users/elohim/play/hypha/hypha_wallet/ios/build/hypha_wallet.ipa