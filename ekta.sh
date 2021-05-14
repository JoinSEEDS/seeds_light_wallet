# /bin/bash

fvm flutter build web --target lib/v2/main.dart --no-sound-safety

cp -rf ./web/* ../ektawallet/

cd ../ektawallet

git add .

git commit -m "."

git push