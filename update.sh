#!/bin/sh

set -o errexit

if [ ! -e "omni.ja.orig" ]; then
  echo "Not omni.ja.orig file."
  echo "Pull the original omni.ja from the device"
  exit 1
fi

echo "Create/cleanup a tmp directory"
rm -rf tmp
mkdir tmp
cd tmp

echo "stop B2G"
adb shell stop b2g
echo "Make sure filesystem is rw"
adb shell mount -o rw,remount /system

echo "Unzip original omni.jar file"
unzip -q ../omni.ja.orig

# Custom part
echo "Files udpate"
cp ~/mozilla/src/toolkit/devtools/server/actors/webapps.js modules/devtools/server/actors/

# End custom part

echo "Repackage omni.ja with modifications"
rm ../omni.ja
zip -q -r ../omni.ja *
cd ..

echo "Pushing new omni.ja file"
adb push omni.ja /system/b2g/omni.ja
echo "Clearing some cache"
adb shell 'cd /data/b2g/mozilla/*.default/ && echo $PWD && rm -rf startupCache/*'

echo "Remount ro"
adb shell mount -o ro,remount /system

echo "Start B2G"
adb shell /system/bin/b2g.sh
