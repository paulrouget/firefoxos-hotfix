#!/bin/sh

PROFILE=a8bj06yh.default

adb shell mount -o rw,remount /system

adb shell stop b2g && \
cd tmp && rm -rf * && \
unzip ../omni.ja.orig ; \
cp ~/mozilla/src/toolkit/devtools/server/actors/styles.js modules/devtools/server/actors/ && \
rm ../omni.ja ; \
zip -r ../omni.ja * && \
cd .. && \
adb push omni.ja /system/b2g/omni.ja && \
adb shell rm /data/b2g/mozilla/$PROFILE/startupCache/* ; \
adb shell mount -o ro,remount /system && \
adb shell /system/bin/b2g.sh

#cp ../shell.js chrome/chrome/content/shell.js && \
#cp ~/mozilla/src/toolkit/devtools/server/actors/device.js modules/devtools/server/actors/ && \
#cp ~/mozilla/src/toolkit/devtools/server/actors/inspector.js modules/devtools/server/actors/ && \
#cp ~/mozilla/src/toolkit/devtools/LayoutHelpers.jsm modules/devtools/ && \
