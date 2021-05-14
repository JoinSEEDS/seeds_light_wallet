# /bin/bash

fvm flutter build web --target lib/v2/main.dart --no-sound-null-safety

cp -rf ./web/* ../qwallet/

cd ../qwallet

git add .

git commit -m "."

git push
