#!/bin/sh

set -o errexit

if [ ! -e "omni.ja.orig" ]; then
  echo "Pulling omni.jar"
  adb pull /system/b2g/omni.ja omni.ja.orig
fi

echo "Cleanup tmp/ directory"
rm -rf tmp
mkdir tmp
cd tmp

echo "stopping B2G..."
adb shell stop b2g

echo "Unzip original omni.jar file"
unzip -q ../omni.ja.orig || echo ignoring zip error

# Custom part
echo "Files udpate"
cp ~/mozilla/src/toolkit/devtools/server/actors/webapps.js modules/devtools/server/actors/
cp ../Webapps.jsm modules/

# End custom part

echo "Repackage omni.ja with modifications"
rm -f ../omni.ja
zip -q -r ../omni.ja *
cd ..

echo "Make sure filesystem is rw"
adb shell mount -o rw,remount /system
echo "Pushing new omni.ja file"
adb push omni.ja /system/b2g/omni.ja
echo "Clearing some cache"
adb shell 'cd /data/b2g/mozilla/*.default && rm startupCache/*'
echo "Remount ro"
adb shell mount -o ro,remount /system

echo "Starting B2G..."
exec adb shell /system/bin/b2g.sh
